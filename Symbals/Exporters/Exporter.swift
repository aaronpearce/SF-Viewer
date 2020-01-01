//
//  Exporter.swift
//  Symbals
//
//  Created by Aaron Pearce on 16/10/19.
//  Copyright © 2019 Sunya. All rights reserved.
//

import UIKit

enum ExportFormat: String, CaseIterable {
    
    case svg = "SVG"
//    case iosSwift = "ios-swift"
//    case iosObjC = "ios-objc"
//    case macosSwift = "macos-swift"
//    case macosObjC = "macos-objc"
    case shortcut = "Shortcut"
    case squaredPng = "Squared PNG"
    case png = "PNG"
    case pdf = "PDF"
//    case iconset = "iconset"
//    case iconsetPDF = "iconset-pdf"
    
    var exporter: Exporter {
        switch self {
            case .svg: return SVGExporter()
//            case .iosSwift: return iOSSwiftExporter()
//            case .iosObjC: return iOSObjCExporter()
//            case .macosSwift: return macOSSwiftExporter()
//            case .macosObjC: return macOSObjCExporter()
            case .shortcut: return ShortcutIconExporter()
            case .squaredPng: return SquaredPNGExporter()
            case .png: return PNGExporter()
            case .pdf: return PDFExporter()
//            case .iconset: return IconsetExporter()
//            case .iconsetPDF: return PDFAssetCatalog()
        }
    }
}

protocol Exporter {
    func export(symbol: Symbol, weight: UIImage.SymbolWeight, scale: UIImage.SymbolScale, in font: CTFont, to folder: URL) throws -> URL
//    func exportGlyphs(in font: Font, matching pattern: String, to folder: URL) throws
//    func exportGlyph(_ symbol: Symbol, in font: CTFont, to folder: URL) throws
    func data(for symbol: Symbol, weight: UIImage.SymbolWeight, scale: UIImage.SymbolScale, in font: CTFont) -> Data
}
