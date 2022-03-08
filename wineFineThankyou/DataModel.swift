//
//  DataModel.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/29.
//

import Foundation
import UIKit

enum StoryBoard: String {
    case launch = "Launch"
    case main = "Main"
    case store = "Store"
    case myPage = "MyPage"
    case readWine = "ReadWine"
    
    var name: String {
        return self.rawValue
    }
}

enum StoreType: Int, CaseIterable {
    case privateShop = 0
    case warehouse = 1
    case mart = 2
    case convenience = 3
    case chain = 4
    case department = 5

    var str: String {
        switch self {
        case .privateShop:
            return "개인샵"
        case .chain:
            return "체인샵"
        case .convenience:
            return "편의점"
        case .mart:
            return "대형마트"
        case .warehouse:
            return "창고형매장"
        case .department:
            return "백화점"
        }
    }
    
    var color: UIColor {
        switch self {
        case .privateShop:
            return UIColor(rgb: 0x7B61FF)
        case .warehouse:
            return UIColor(rgb: 0xF52837)
        case .mart:
            return UIColor(rgb: 0xFE9220)
        case .convenience:
            return UIColor(rgb: 0xF7C411)
        case .chain:
            return UIColor(rgb: 0xFF89BC)
        case .department:
            return UIColor(rgb: 0x34B6E7)
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
    let storeFk: Int
    let boughtDate: Date
}

struct WineStoreInfo {
    let key: Int
    let storeName: String
    let classification: StoreType
    let callNumber: String
    let location: String
    let openingHours: String
    let homepage: String
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

class UserData {
    static var isUserLogin : Bool {
        get {
            //MARK: TEST
            return UserDefaults.standard.bool(forKey: "IsUserLoginBefore")
        }
        set(val) {
            UserDefaults.standard.setValue(val, forKey: "IsUserLoginBefore")
        }
    }
    
    static var userOptions: [String] {
        get {
            let rtnVal = UserDefaults.standard.string(forKey: "UserSelectOption") ?? ""
            return rtnVal.components(separatedBy: ",")
        }
        set(val) {
            var saveVal: String = ""
            val.forEach { saveVal += ($0 + ",") }
            UserDefaults.standard.setValue(saveVal, forKey: "UserSelectOption")
        }
    }
    
    static var accessToken: String {
        get {
            return UserDefaults.standard.string(forKey: "AccessToken") ?? ""
        }
        set(val) {
            UserDefaults.standard.setValue(val, forKey: "AccessToken")
        }
    }
}
