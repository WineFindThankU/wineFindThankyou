//
//  ExtFunc.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/12.
//

import Foundation
import UIKit

func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let nav = base as? UINavigationController {
        return topViewController(base: nav.visibleViewController)
    }
    if let tab = base as? UITabBarController {
        if let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
    }
    if let presented = base?.presentedViewController {
        return topViewController(base: presented)
    }
    return base
}

extension String {
    func rangeBoldString(_ size: CGFloat, range: String) -> NSMutableAttributedString {
        let bold = UIFont.boldSystemFont(ofSize: size)
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(.font, value: bold, range: (self as NSString).range(of: range))
        return attributedString
    }
    func rangeSizeUp(_ size: CGFloat, font: UIFont.Weight = .regular, range: String) -> NSMutableAttributedString {
        let bold = UIFont.systemFont(ofSize: size, weight: font)
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(.font, value: bold, range: (self as NSString).range(of: range))
        return attributedString
    }
}
