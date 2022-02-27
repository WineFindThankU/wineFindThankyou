//
//  UIColor+Extensions.swift
//  wineFindThankyou
//
//  Created by suding on 2022/02/27.
//

import Foundation
import UIKit

typealias WordDetailColor = UIColor
typealias FolderColor = UIColor

extension UIColor {
    static let standardColor = UIColor(named: "standard_color") ?? #colorLiteral(red: 0.4823529412, green: 0.3811762751, blue: 1, alpha: 1)
    static let standardFont = UIColor(named: "standard_font") ?? #colorLiteral(red: 0.1176470444, green: 0.1176470444, blue: 0.1176470444, alpha: 1)
    static let gray30 = UIColor(named: "gray30") ?? #colorLiteral(red: 0.9333333333, green: 0.9450980392, blue: 0.9568627451, alpha: 1)
    static let gray40 = UIColor(named: "gray40") ?? #colorLiteral(red: 0.8196078431, green: 0.8431372549, blue: 0.8666666667, alpha: 1)
    static let folder00 = UIColor(named: "folder00") ?? #colorLiteral(red: 0.7490196078, green: 0.8039215686, blue: 0.8705882353, alpha: 1)
    static let folder01 = UIColor(named: "folder01") ?? #colorLiteral(red: 0.2470588235, green: 0.7803921569, blue: 0.8588235294, alpha: 1)
    static let folder02 = UIColor(named: "folder02") ?? #colorLiteral(red: 0.4470588235, green: 0.7529411765, blue: 0.9921568627, alpha: 1)
    static let folder03 = UIColor(named: "folder03") ?? #colorLiteral(red: 0.568627451, green: 0.6509803922, blue: 0.9882352941, alpha: 1)
    static let folder04 = UIColor(named: "folder04") ?? #colorLiteral(red: 0.6941176471, green: 0.5882352941, blue: 0.9921568627, alpha: 1)
    static let folder05 = UIColor(named: "folder05") ?? #colorLiteral(red: 0.8941176471, green: 0.6, blue: 0.9647058824, alpha: 1)
    static let folder06 = UIColor(named: "folder06") ?? #colorLiteral(red: 0.9607843137, green: 0.6470588235, blue: 0.7607843137, alpha: 1)
    
    var name: String? {
        switch self {
        case UIColor.folder00: return "folder00"
        case UIColor.folder01: return "folder01"
        case UIColor.folder02: return "folder02"
        case UIColor.folder03: return "folder03"
        case UIColor.folder04: return "folder04"
        case UIColor.folder05: return "folder05"
        case UIColor.folder06: return "folder06"
        default: return nil
        }
    }
}
