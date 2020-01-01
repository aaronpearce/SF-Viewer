//
//  PNGExporter.swift
//  Symbals
//
//  Created by Aaron Pearce on 16/10/19.
//  Copyright © 2019 Sunya. All rights reserved.
//

import UIKit

struct PNGExporter: Exporter {
    
    func export(symbol: Symbol, weight: UIImage.SymbolWeight, scale: UIImage.SymbolScale, in font: CTFont, to folder: URL) throws -> URL {
        let name = "\(symbol.shortName).png"
        let file = folder.appendingPathComponent(name)
        let symbolData = data(for: symbol, weight: weight, scale: scale, in: font)
        try symbolData.write(to: file)
        return file
    }
    
    func data(for symbol: Symbol, weight: UIImage.SymbolWeight, scale: UIImage.SymbolScale, in font: CTFont, viewScale: CGFloat) -> Data {
        guard let pathTuple = try? symbol.generateCGPath(for: weight, scale: scale) else { return Data() }
        let size = pathTuple.boundingBox.size
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = viewScale
        format.opaque = false
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        
        let imageData = renderer.pngData { (context) in
            context.cgContext.translateBy(x: 0.0, y: size.height)
            context.cgContext.scaleBy(x: 1.0, y: -1.0)
            context.cgContext.setShouldAntialias(true)
            context.cgContext.addPath(pathTuple.path)
            context.cgContext.setFillColor(UIColor.black.cgColor)
            context.cgContext.fillPath()
        }

        return imageData
    }
    
    func data(for symbol: Symbol, weight: UIImage.SymbolWeight, scale: UIImage.SymbolScale, in font: CTFont) -> Data {
        return data(for: symbol, weight: weight, scale: scale, in: font, viewScale: UIScreen.main.scale)
    }
    
}
