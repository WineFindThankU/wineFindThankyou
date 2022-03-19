//
//  ExtFunc.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/12.
//

import Foundation
import UIKit

func topViewController(baseParam: UIViewController? = nil) -> UIViewController? {
    var base = baseParam
    if base == nil {
        base = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first?.rootViewController
    }
    
    if let nav = base as? UINavigationController {
        return topViewController(baseParam: nav.visibleViewController)
    }
    if let tab = base as? UITabBarController {
        if let selected = tab.selectedViewController {
            return topViewController(baseParam: selected)
        }
    }
    if let presented = base?.presentedViewController {
        return topViewController(baseParam: presented)
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
    
    func rangeSetColor(color: UIColor, range: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(.foregroundColor, value: color, range: (self as NSString).range(of: range))
        return attributedString
    }
}

extension UITextField {
    func setPadding(left: CGFloat? = nil, right: CGFloat? = nil){
        if let left = left {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
        if let right = right {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
}

extension UIViewController {
    static var identifier: String {
        return self.description().components(separatedBy: ".").last ?? ""
    }
}
