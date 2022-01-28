//
//  DataModel.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/29.
//

import Foundation
import UIKit
enum StoreType {
    case privateShop
    case chainShop
    case convenience24
    var str: String {
        switch self {
        case .privateShop:
            return "개인샵"
        case .chainShop:
            return "체인샵"
        case .convenience24:
            return "편의점"
        }
    }
}

struct WineStoreInfo {
    let storeName: String
    let classification: StoreType
    let callNumber: String
    let location: String
    let openingHours: String
    let homepage: String
    let wines: [WineInfo]
}

struct WineInfo {
    let img: UIImage
    let name: String
}
