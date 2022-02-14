//
//  ExtUIColor.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/25.
//

import Foundation
import UIKit

enum Theme {
    case gray
    case purple
    case black
    case blacktext
    case white

    var color: UIColor {
        switch self {
        case .gray:
            return UIColor(rgb: 0xEEEEEE)
        case .purple:
            return UIColor(rgb: 0x7B61FF)
        case .black:
            return UIColor.black
        case .blacktext:
            return UIColor.black.withAlphaComponent(0.8)
        case .white:
            return UIColor.white
        }
    }
}


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }

    convenience init(rgb: Int, a: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            a: a
        )
    }
    
    func getLineColor() -> UIColor {
        return UIColor(rgb: 0xEEEEEE)
    }
}


extension UIColor {
 
    
    @nonobjc class var personalShop: UIColor {
        return UIColor(red: 123.0, green: 103.0, blue: 251.0, alpha: 1.0)
    }
    
    @nonobjc class var chainShop: UIColor {
        return UIColor(red: 123.0, green: 103.0, blue: 251.0, alpha: 1.0)
    }
    
    @nonobjc class var convinStore: UIColor {
        return UIColor(red: 123.0, green: 103.0, blue: 251.0, alpha: 1.0)
    }
    
    @nonobjc class var bigMart: UIColor {
        return UIColor(red: 123.0, green: 103.0, blue: 251.0, alpha: 1.0)
    }
    
    @nonobjc class var boxMarket: UIColor {
        return UIColor(red: 123.0, green: 103.0, blue: 251.0, alpha: 1.0)
    }
    
    @nonobjc class var departStore: UIColor {
        return UIColor(red: 123.0, green: 103.0, blue: 251.0, alpha: 1.0)
    }
    
}
