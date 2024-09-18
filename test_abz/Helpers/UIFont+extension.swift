//
//  UIFont+extension.swift
//  test_abz
//
//  Created by Anton on 18.09.2024.
//

import Foundation
import UIKit

extension UIFont {
    static func nunitoSansExtraLight(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "NunitoSans-12ptExtraLight", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func nunitoSansRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "NunitoSans-12ptExtraLight_Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func nunitoSansLight(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "NunitoSans-12ptExtraLight_Light", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func nunitoSansMedium(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "NunitoSans-12ptExtraLight_Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func nunitoSansSemiBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "NunitoSans-12ptExtraLight_SemiBold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    static func nunitoSansBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "NunitoSans-12ptExtraLight_Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    static func nunitoSansExtraBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "NunitoSans-12ptExtraLight_ExtraBold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    static func nunitoSansBlack(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "NunitoSans-12ptExtraLight_Black", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
}
