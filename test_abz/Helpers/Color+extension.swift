//
//  Color+extension.swift
//  test_abz
//
//  Created by Anton on 17.09.2024.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hexFormatted = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hexFormatted).scanHexInt64(&int)
        let red, green, blue: CGFloat
        switch hexFormatted.count {
        case 3:
            (red, green, blue) = (
                CGFloat((int >> 8) * 17) / 255,
                CGFloat((int >> 4 & 0xF) * 17) / 255,
                CGFloat((int & 0xF) * 17) / 255
            )
        case 6:
            (red, green, blue) = (
                CGFloat((int >> 16) & 0xFF) / 255,
                CGFloat((int >> 8) & 0xFF) / 255,
                CGFloat(int & 0xFF) / 255
            )
        default:
            (red, green, blue) = (1, 1, 1)
        }
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
