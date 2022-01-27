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
    case white
    var color: UIColor {
        switch self {
        case .gray:
            return UIColor(rgb: 0xEEEEEE)
        case .purple:
            return UIColor(rgb: 0x7B61FF)
        case .black:
            return UIColor.black
        case .white:
            return UIColor.white
        }
    }
}

//For Using RGB hexa value
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
