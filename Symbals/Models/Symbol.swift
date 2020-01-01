//
//  mbol.swift
//  Symbals
//
//  Created by Aaron Pearce on 19/10/19.
//  Copyright © 2019 Sunya. All rights reserved.
//

import UIKit

/*
 {
   "Additional Search Metadata": "",
   "Categories": "indicies",
   "Glyph Order": 1966,
   "NEW  PUAs": 100600,
   "Non-modifiable": "FALSE",
   "Protected Symbol Notes": "",
   "RTL extension": "",
   "semantic.name.1": "",
   "semantic.name.2": "",
   "semantic.name.3": "",
   "short.name": "50.square.fill",
   "unicodes": "NO"
 }
 */
struct Symbol: Codable {
    
    enum Element {
        case move(CGPoint)
        case line(CGPoint)
        case quadCurve(CGPoint, CGPoint)
        case curve(CGPoint, CGPoint, CGPoint)
        case close
    }
    
    let additionalSearchMetadata: String?
    let categories: [String]?
    let glyphOrder: Int
    let newPUAs: String
    let nonModifiable: Bool
    let protectedSymbolNotes: String?
    let rtlExtension: String?
    let semanticName1: String?
    let semanticName2: String?
    let semanticName3: String?
    let shortName: String
    let unicodes: String?

    enum CodingKeys: String, CodingKey {
        case additionalSearchMetadata = "Additional Search Metadata"
        case categories = "Categories"
        case glyphOrder = "Glyph Order"
        case newPUAs = "NEW  PUAs"
        case nonModifiable = "Non-modifiable"
        case protectedSymbolNotes = "Protected Symbol Notes"
        case rtlExtension = "RTL extension"
        case semanticName1 = "semantic.name.1"
        case semanticName2 = "semantic.name.2"
        case semanticName3 = "semantic.name.3"
        case shortName = "short.name"
        case unicodes
    }
    
    init(from decoder: Decoder) throws {
        func decodeIntoStringIfInt(_ values:  KeyedDecodingContainer<Symbol.CodingKeys>, key: Symbol.CodingKeys) -> String {
            if let value = try? values.decode(Int.self, forKey: key) {
                return String(value)
            } else {
                return try! values.decode(String.self, forKey: key)
            }
        }
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        shortName = try values.decode(String.self, forKey: .shortName)
        newPUAs = decodeIntoStringIfInt(values, key: .newPUAs)
        categories = (try? values.decode(String.self, forKey: .categories))?.components(separatedBy: ", ")
        additionalSearchMetadata = try? values.decode(String.self, forKey: .additionalSearchMetadata)
        protectedSymbolNotes = try? values.decode(String.self, forKey: .protectedSymbolNotes)
        rtlExtension = try? values.decode(String.self, forKey: .rtlExtension)
        semanticName1 = try? values.decode(String.self, forKey: .semanticName1)
        semanticName2 = try? values.decode(String.self, forKey: .semanticName2)
        semanticName3 = try? values.decode(String.self, forKey: .semanticName3)
        unicodes = try? values.decode(String.self, forKey: .unicodes)
        
        if let value = try? values.decode(String.self, forKey: .glyphOrder) {
            glyphOrder = Int(value) ?? 0
        } else {
            glyphOrder = try values.decode(Int.self, forKey: .glyphOrder)
        }
        
        if let value = try? values.decode(String.self, forKey: .nonModifiable) {
            if value == "TRUE" {
                nonModifiable = true
            } else {
                nonModifiable = false
            }
        } else {
            nonModifiable = try values.decode(Bool.self, forKey: .nonModifiable)
        }
    }
    
    func generateCGPath(for weight: UIImage.SymbolWeight, scale: UIImage.SymbolScale) throws -> (path: CGPath, boundingBox: CGRect, originOffset: CGPoint) {
        let name = "uni\(newPUAs).\(scale.fileString)"
        guard let font = Symbols.getFont(for: weight) else { throw SymbolsError("Font not found") }
        var glyph = CTFontGetGlyphWithName(font, name as CFString)

        var box = CGRect.zero
        CTFontGetBoundingRectsForGlyphs(font, .default, &glyph, &box, 1)
        let paddedBox: CGRect
        let paddedBoxMultiplier: CGFloat = box.origin.y > 0 ? 2 : -2
        paddedBox = CGRect(x: 0, y: 0, width: box.width + (2 * box.origin.x), height: box.height + (paddedBoxMultiplier * box.origin.y))

        let boundingBox = paddedBox
        let originOffset = box.origin

        let path = CTFontCreatePathForGlyph(font, glyph, nil)

        let copy: CGPath?
        if box.origin.y > 0 {
            copy = path
        } else {
            var transform = CGAffineTransform(translationX: 0, y: -2 * originOffset.y)
            copy = path?.copy(using: &transform)
        }
        let cgPath = copy ?? CGPath(rect: CGRect(origin: .zero, size: paddedBox.size), transform: nil)
        
        return (cgPath, boundingBox, originOffset)
    }
    
    func enumerateElements(enumerator: (CGPoint?, Element) -> Void, for cgPath: CGPath) {
        
        var currentPoint: CGPoint?
        cgPath.applyWithBlock { elementRef in
            let pathElement = elementRef.pointee
            
            let points = [
                pathElement.points[0],
                pathElement.points[1],
                pathElement.points[2]
            ]
            
            let element: Element
            let newCurrentPoint: CGPoint?
            
            switch pathElement.type {
                case .moveToPoint:
                    element = .move(points[0])
                    newCurrentPoint = points[0]
                
                case .addLineToPoint:
                    element = .line(points[0])
                    newCurrentPoint = points[0]
                
                case .addQuadCurveToPoint:
                    element = .quadCurve(points[0], points[1])
                    newCurrentPoint = points[0]
                
                case .addCurveToPoint:
                    element = .curve(points[0], points[1], points[2])
                    newCurrentPoint = points[0]
                
                case .closeSubpath:
                    element = .close
                    newCurrentPoint = nil
                
                @unknown default: return
            }
            
            enumerator(currentPoint, element)
            currentPoint = newCurrentPoint
        }
    }
}
