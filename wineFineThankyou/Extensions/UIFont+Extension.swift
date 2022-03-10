//
//  UIFont+Extension.swift
//  wineFindThankyou
//
//  Created by suding on 2022/03/10.
//

import UIKit

extension UIFont {
    static func gaeguRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Gaegu-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }

}
