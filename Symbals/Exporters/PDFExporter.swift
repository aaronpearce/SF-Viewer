//
//  PDFExporter.swift
//  Symbals
//
//  Created by Aaron Pearce on 16/10/19.
//  Copyright © 2019 Sunya. All rights reserved.
//

import UIKit

struct PDFExporter: Exporter {
    
    func export(symbol: Symbol, weight: UIImage.SymbolWeight, scale: UIImage.SymbolScale, in font: CTFont, to folder: URL) throws -> URL {
        let name = "\(symbol.shortName).pdf"
        let file = folder.appendingPathComponent(name)
        let symbolData = data(for: symbol, weight: weight, scale: scale, in: font)
        try symbolData.write(to: file)
        return file
    }

    func data(for symbol: Symbol, weight: UIImage.SymbolWeight, scale: UIImage.SymbolScale, in font: CTFont) -> Data {
        let destination = NSMutableData()
        guard let dataConsumer = CGDataConsumer(data: destination as CFMutableData) else { return Data() }
        
        guard let pathTuple = try? symbol.generateCGPath(for: weight, scale: scale) else { return Data() }

        var box = pathTuple.boundingBox
        guard let pdf = CGContext(consumer: dataConsumer, mediaBox: &box, nil) else { return Data() }
        
        let pageInfo = [
            kCGPDFContextMediaBox: Data(bytes: &box, count: MemoryLayout<CGRect>.size) as CFData
        ]
        pdf.beginPDFPage(pageInfo as CFDictionary)
        pdf.setShouldAntialias(true)
        pdf.addPath(pathTuple.path)

        pdf.setFillColor(UIColor.black.cgColor)
        pdf.fillPath()
        pdf.endPDFPage()
        pdf.closePDF()
        
        return destination as Data
    }
}

