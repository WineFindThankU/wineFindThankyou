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
    var wines: [WineInfo]
    
    mutating func addWines(_ wineInfo: WineInfo){
        wines.append(wineInfo)
    }
}

enum WineType: Int, CaseIterable {
    case white = 0
    case red = 1
    case rose = 2
    case sparkling = 3
    case fortified = 4
    var idx: Int {
        return self.rawValue
    }
    var str: String {
        switch self {
        case .white:
            return "화이트"
        case .red:
            return "레드"
        case .rose:
            return "로제"
        case .sparkling:
            return "스파클링"
        case .fortified:
            return "주정강화"
        }
    }
    
    var color: UIColor {
        switch self {
        case .white:
            return UIColor(rgb: 0x8FDA00)
        case .red:
            return UIColor(rgb: 0xE10051)
        case .rose:
            return UIColor(rgb: 0xFD8DA1)
        case .sparkling:
            return UIColor(rgb: 0xFE9220)
        case .fortified:
            return UIColor(rgb: 0x8215C4)
        }
    }
}

struct WineInfo {
    let img: UIImage
    let korName: String
    let engName: String
    let wineType: WineType
    let cepage: String
    let from: String
    let vintage: String
    let alchol: String
}

class UserData {
    static var isUserLogin : Bool {
        get {
            //MARK: TEST
            return false
//            return UserDefaults.standard.bool(forKey: "IsUserLoginBefore")
        }
        set(val) {
            UserDefaults.standard.setValue(val, forKey: "IsUserLoginBefore")
        }
    }
}
