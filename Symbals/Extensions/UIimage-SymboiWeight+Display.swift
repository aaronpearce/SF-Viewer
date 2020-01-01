//
//  UIimage-SymboiWeight+Display.swift
//  Symbals
//
//  Created by Aaron Pearce on 21/10/19.
//  Copyright © 2019 Sunya. All rights reserved.
//

import UIKit

extension UIImage.SymbolWeight {
    
    static var allCases: [UIImage.SymbolWeight] {
        return [.ultraLight, .thin, .light, .regular, .medium, .semibold, .bold, .heavy, .black]
    }

    var displayString: String {
        switch self {
        case .unspecified:
            return "Unspecified"
        case .ultraLight:
            return "Ultralight"
        case .thin:
            return "Thin"
        case .light:
            return "Light"
        case .regular:
            return "Regular"
        case .medium:
            return "Medium"
        case .semibold:
            return "Semibold"
        case .bold:
            return "Bold"
        case .heavy:
            return "Heavy"
        case .black:
            return "Black"
        @unknown default:
            return "Unspecified"
        }
    }
    
    var fontName: String {
        return "SF-Pro-Text-\(displayString)"
    }
}
