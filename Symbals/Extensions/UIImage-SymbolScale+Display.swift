//
//  UIImage-SymbolScale+Display.swift
//  Symbals
//
//  Created by Aaron Pearce on 21/10/19.
//  Copyright © 2019 Sunya. All rights reserved.
//

import UIKit

extension UIImage.SymbolScale {
    static var allCases: [UIImage.SymbolScale] {
        return [.small, .medium, .large]
    }
    
    var displayString: String {
        switch self {
        case .default:
            return "Default"
        case .small:
            return "Small"
        case .medium:
            return "Medium"
        case .large:
            return "Large"
        default:
            return "Unspecified"
        }
    }
    
    var fileString: String {
        switch self {
        case .default:
            return "small"
        case .small:
            return "small"
        case .medium:
            return "medium"
        case .large:
            return "large"
        default:
            return "small"
        }
    }
}
