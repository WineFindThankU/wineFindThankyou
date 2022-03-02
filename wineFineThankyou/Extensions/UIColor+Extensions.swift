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
    static let personalShop = UIColor(named: "personal_shop") ?? #colorLiteral(red: 0.4826743197, green: 0.4050789065, blue: 1, alpha: 1)
    static let chainShop = UIColor(named: "chain_shop") ?? #colorLiteral(red: 1, green: 0.5052959919, blue: 0.7439669967, alpha: 1)
    static let convinStore = UIColor(named: "convin_store") ?? #colorLiteral(red: 1, green: 0.7586414218, blue: 0, alpha: 1)
    static let bigMart = UIColor(named: "big_mart") ?? #colorLiteral(red: 1, green: 0.5447430015, blue: 0, alpha: 1)
    static let containerMart = UIColor(named: "container_mart") ?? #colorLiteral(red: 1, green: 0, blue: 0.1622434556, alpha: 1)
    static let departmentStore = UIColor(named: "department_store") ?? #colorLiteral(red: 0, green: 0.7260835767, blue: 0.926150918, alpha: 1)
    static let folder04 = UIColor(named: "folder04") ?? #colorLiteral(red: 0.6941176471, green: 0.5882352941, blue: 0.9921568627, alpha: 1)
    static let folder05 = UIColor(named: "folder05") ?? #colorLiteral(red: 0.8941176471, green: 0.6, blue: 0.9647058824, alpha: 1)
    static let folder06 = UIColor(named: "folder06") ?? #colorLiteral(red: 0.9607843137, green: 0.6470588235, blue: 0.7607843137, alpha: 1)
    static let gray30 = UIColor(named: "gray30") ?? #colorLiteral(red: 0.8784312606, green: 0.878431499, blue: 0.8827369809, alpha: 1)
    
    var name: String? {
        switch self {
        case UIColor.convinStore: return "convinStore"
        case UIColor.bigMart: return "bigMart"
        case UIColor.containerMart: return "containerMart"
        case UIColor.folder04: return "folder04"
        case UIColor.folder05: return "folder05"
        case UIColor.folder06: return "folder06"
        default: return nil
        }
    }
}
