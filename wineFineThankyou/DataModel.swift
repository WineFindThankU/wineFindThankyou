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

struct WineInfo {
    let img: UIImage
    let name: String
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
