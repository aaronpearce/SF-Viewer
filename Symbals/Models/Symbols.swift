//
//  Symbol.swift
//  MetaSymbols
//
//  Created by Aaron Pearce on 15/10/19.
//  Copyright © 2019 Sunya. All rights reserved.
//

import UIKit
import CommonCrypto
import CSV

struct SymbolsError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}

class Symbols {
    
    init(_ callback: () -> ()) {
        readCSV(callback)
    }

    var allSymbols = [Symbol]()
    var filteredSymbols = [Symbol]()
    
    var symbolsByCategory: [String: [Symbol]] {
        var symbolsByCategory = [String: [Symbol]]()
        
        for symbol in filteredSymbols {
            func insertInto(category: String) {
                if symbolsByCategory.keys.contains(category) {
                    symbolsByCategory[category]?.append(symbol)
                } else {
                    symbolsByCategory[category] = [symbol]
                }
            }

            if let categories = symbol.categories {
                for category in categories {
                    insertInto(category: category)
                }
            } else {
                insertInto(category: "non-categorized")
            }
            
        }
        
        return symbolsByCategory
    }
    
    var symbolKeys: [String] {
        var keys = symbolsByCategory.keys.sorted()
        if let appleIndex = keys.firstIndex(of: "apple") {
            keys.remove(at: appleIndex)
            keys.append("apple")
        }
        return keys
    }
    
    func symbol(for indexPath: IndexPath) -> Symbol? {
        let key = symbolKeys[indexPath.section]
        let symbols = symbolsByCategory[key]?.sorted(by: { (s1, s2) -> Bool in
            s1.glyphOrder < s2.glyphOrder
        })
        
        return symbols?[indexPath.row]
    }
    
    static func getFont(for weight: UIImage.SymbolWeight = .regular) -> CTFont? {
        guard let fontURL = Bundle.main.url(forResource: weight.fontName, withExtension: "otf") else {
            print("No font file found")
            return nil
        }

        guard let provider = CGDataProvider(url: fontURL as CFURL) else { return nil }
        guard let cgFont = CGFont(provider) else { return nil }

        let attributes = [
            kCTFontTraitsAttribute: [
                kCTFontWeightTrait: UIFont.Weight.regular.rawValue
            ]
        ]
        let ctAttributes = CTFontDescriptorCreateWithAttributes(attributes as CFDictionary)
        let font = CTFontCreateWithGraphicsFont(cgFont, 44.0, nil, ctAttributes)
    
        return font
    }
    
    func readCSV(_ callback: () -> ()) {
        guard let font = Symbols.getFont() else { return }

        guard let data = CTFontCopyDecodedSYMPData(font) else {
            print("No SYMP data found.")
            return
        }
        guard let csv = String(data: data, encoding: .utf8) else {
            print("Failed to stringify")
            return
        }

        var records = [Symbol]()
        do {
            let reader = try CSVReader(string: csv, hasHeaderRow: true)
            let decoder = CSVRowDecoder()
            while reader.next() != nil {
                let row = try decoder.decode(Symbol.self, from: reader)
                records.append(row)
            }
        } catch {
            print(error)
        }
        
        self.allSymbols = records
        self.filteredSymbols = allSymbols
        callback()
    }
    
    func filter(for searchText: String?) {
        if let searchText = searchText?.lowercased(), searchText != "" {
            filteredSymbols = allSymbols.filter {
                        $0.additionalSearchMetadata?.contains(searchText) ?? false ||
                        $0.shortName.contains(searchText) ||
                        $0.semanticName1?.contains(searchText) ?? false ||
                        $0.semanticName2?.contains(searchText) ?? false ||
                        $0.semanticName3?.contains(searchText) ?? false ||
                        $0.categories?.contains(where: { $0.range(of: searchText, options: .caseInsensitive) != nil }) ?? false
            }
        } else {
            filteredSymbols = allSymbols
        }
    }
}


private func CTFontCopyDecodedSYMPData(_ font: CTFont) -> Data? {
    func fourCharCode(_ string: String) -> FourCharCode {
        return string.utf16.reduce(0, {$0 << 8 + FourCharCode($1)})
    }
    
    let tag = fourCharCode("symp")
    guard let data = CTFontCopyTable(font, tag, []) else { return nil }
    guard let base64String = String(data: data as Data, encoding: .utf8) else { return nil }
    guard let encoded = NSData(base64Encoded: base64String) else { return nil }
    guard let decoded = NSMutableData(length: encoded.length) else { return nil }
    
    var key: Array<UInt8> = [0xB8, 0x85, 0xF6, 0x9E, 0x39, 0x8C, 0xBA, 0x72, 0x40, 0xDB, 0x49, 0x6B, 0xE8, 0xC6, 0x14, 0x88, 0x54, 0x9F, 0x1F, 0x88, 0x5D, 0x47, 0x6B, 0x2E, 0x2C, 0xC1, 0x14, 0xF1, 0x3B, 0x17, 0x21, 0x20]
    var iv: Array<UInt8> = [0xEF, 0xB0, 0xD1, 0x2E, 0xFA, 0xC5, 0x91, 0x14, 0xC3, 0xE5, 0xB9, 0x12, 0x70, 0xF0, 0xC0, 0x46]
    
    var bytesWritten = 0
    let result = CCCrypt(CCOperation(kCCDecrypt),
                         CCAlgorithm(kCCAlgorithmAES),
                         CCOptions(kCCOptionPKCS7Padding),
                         &key, key.count,
                         &iv,
                         encoded.bytes, encoded.length,
                         decoded.mutableBytes, decoded.length,
                         &bytesWritten)
    
    guard result == kCCSuccess else { return nil }
    decoded.length = bytesWritten
    return decoded as Data
}

internal func CSVFields(_ line: String) -> Array<String> {
    var fields = Array<String>()
    
    var insideQuote = false
    var fieldStart = line.startIndex
    var currentIndex = fieldStart
    while currentIndex < line.endIndex {
        let character = line[currentIndex]
        
        if insideQuote == false {
            if character == "," {
                let subString = line[fieldStart ..< currentIndex]
                fields.append(String(subString))
                fieldStart = line.index(after: currentIndex)
            } else if character == "\"" {
                insideQuote = true
            }
        } else {
            if character == "\"" { insideQuote = false }
        }
        
        if currentIndex >= line.endIndex { break }
        currentIndex = line.index(after: currentIndex)
    }
    
    let lastField = line[fieldStart ..< line.endIndex]
    fields.append(String(lastField))
    
    return fields
}
