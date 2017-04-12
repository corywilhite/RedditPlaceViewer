//
//  HexColor.swift
//  PlaceViewer
//
//  Created by Cory Wilhite on 4/11/17.
//  Copyright © 2017 Cory Wilhite. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// Creates a UIColor from a hexadecimal string.
    ///
    /// If the string is 3 or 6 characters long, the alpha parameter is used.
    ///
    /// If the string is 8 characters long, the alpha is assumed to be the last two characters of the string
    ///
    /// If a hexadecimal string fails to be transformed and represented properly, clearColor is returned
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        
        guard hexString.isEmpty == false else {
            fatalError("Hex string passed in was empty. Returning clear color")
        }
        
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted) // trims anything not in a-z, A-Z, 0-9
        
        var int = UInt32() // will be populated with a scanned String -> Int conversion
        
        let successfullyScanned = Scanner(string: hex).scanHexInt32(&int)
        
        guard successfullyScanned else {
            fatalError("Failed to scan the hex string to an int. Returning clear color")
        }
        
        let r, g, b, a: UInt32
        
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (r, g, b, a) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17, UInt32(CGFloat(255) * alpha))
        case 6: // RGB (24-bit)
            (r, g, b, a) = (int >> 16, int >> 8 & 0xFF, int & 0xFF, UInt32(CGFloat(255) * alpha))
        case 8: // RGBA (32-bit)
            (r, g, b, a) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            fatalError("Unsupported character length for color hex string. Returning clear color")
        }
        
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
}
