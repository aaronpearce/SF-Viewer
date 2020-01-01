//
//  SVGExporter.swift
//  Symbals
//
//  Created by Aaron Pearce on 16/10/19.
//  Copyright © 2019 Sunya. All rights reserved.
//

import UIKit

struct SVGExporter: Exporter {
    
    private func format(_ point: CGPoint) -> String {
        return "\(point.x),\(point.y)"
    }
    
    func export(symbol: Symbol, weight: UIImage.SymbolWeight, scale: UIImage.SymbolScale, in font: CTFont, to folder: URL) throws -> URL {
        let name = "\(symbol.shortName).svg"
        let file = folder.appendingPathComponent(name)
        let symbolData = data(for: symbol, weight: weight, scale: scale, in: font)
        try symbolData.write(to: file)
        return file
    }
     
    func data(for symbol: Symbol, weight: UIImage.SymbolWeight, scale: UIImage.SymbolScale, in font: CTFont) -> Data {
        var lines = Array<String>()
        if let restriction = symbol.protectedSymbolNotes {
            lines.append("<!--")
            lines.append("    " + restriction)
            lines.append("-->")
        }
        
        guard let pathTuple = try? symbol.generateCGPath(for: weight, scale: scale) else { return Data() }
        
        let direction = " direction='ltr'" // symbol.allowsMirroring ? "" : "
        lines.append("<svg width='\(pathTuple.boundingBox.width)px' height='\(pathTuple.boundingBox.height)px'\(direction) xmlns='http://www.w3.org/2000/svg' version='1.1'>")
        lines.append("<g fill-rule='nonzero' transform='scale(1,-1) translate(0,-\(pathTuple.boundingBox.height))'>")
        lines.append("<path fill='black' stroke='black' fill-opacity='1.0' stroke-width='1' d='")
        symbol.enumerateElements(enumerator: { (_, element) in
            switch element {
                case .move(let p): lines.append("    M \(format(p))")
                case .line(let p): lines.append("    L \(format(p))")
                case .quadCurve(let p, let c): lines.append("    Q \(format(p)) \(format(c))")
                case .curve(let p, let c1, let c2): lines.append("    C \(format(p)) \(format(c1)) \(format(c2))")
                case .close: lines.append("    Z")
            }
        }, for: pathTuple.path)

        lines.append("' />")
        lines.append("</g>")
        lines.append("</svg>")
        
        let svg = lines.joined(separator: "\n")
        
        return Data(svg.utf8)
    }
}
