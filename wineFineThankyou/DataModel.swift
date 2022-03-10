//
//  DataModel.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/29.
//

import Foundation
import UIKit
import SwiftyJSON

enum StoryBoard: String {
    case launch = "Launch"
    case main = "Main"
    case shop = "Shop"
    case myPage = "MyPage"
    case readWine = "ReadWine"
    
    var name: String {
        return self.rawValue
    }
}

enum ShopType: Int, CaseIterable {
    case all = 0
    case privateShop = 1
    case warehouse = 2
    case mart = 3
    case convenience = 4
    case chain = 5
    case department = 6
    
    var str: String {
        switch self {
        case .all:
            return "전체"
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
        case .all:
            return .black
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
    
    static var allOfCases: [ShopType]{
        return [.privateShop, .warehouse, .mart, .convenience, .chain, .department]
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
    let shopFk: String
    let boughtDate: Date
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

class Shop {
    let key: String
    private let homepage: String?
    private let category: String?
    private let address: String?
    private let name: String?
    private let tellNumber: String?
    private var bookmark: Bool
    let latitude: Double
    let longtitude: Double
    var userWines = [WineInfo]()
    init(_ param: JSON) {
        self.key = param["sh_no"].string ?? ""
        self.homepage = param["sh_url"].string
        self.bookmark = param["sh_bookmark"].bool ?? false
        self.category = param["sh_category"].string
        self.address = param["sh_address"].string
        self.name = param["sh_name"].string
        self.tellNumber = param["sh_tell"].string
        self.latitude = param["sh_latitude"].double ?? 0.0
        self.longtitude = param["sh_longitude"].double ?? 0.0
    }
    
    var isBookmarked: Bool {
        get {
            return self.bookmark
        } set(val) {
            self.bookmark = val
        }
    }
    var categoryType: ShopType {
        guard let category = category else {
            return .privateShop
        }

        switch category.uppercased() {
        case "CONVENIENCE":
            return .convenience
        case "PRIVATE":
            return .privateShop
        case "CHAIN":
            return .chain
        case "CONVENIENCE":
            return .convenience
        case "SUPERMARKET":
            return .mart
        case "WAREHOUSE":
            return .warehouse
        case "DEPARTMENT":
            return .department
        default:
            return .privateShop
        }
    }
    
    var nnName: String {
        guard let name = name, !name.isEmpty
        else { return "이름 없음" }
        return name
    }
    
    var nnTellNumber: String {
        guard let tellNumber = tellNumber, !tellNumber.isEmpty
        else { return "저장된 번호 없음" }
        return tellNumber
    }
    
    var nnAddress: String {
        guard let address = address, !address.isEmpty
        else { return "저장된 주소 없음" }
        return address
    }
    var nnHomepage: String {
        guard let homepage = homepage, !homepage.isEmpty
        else { return "저장된 홈페이지 없음" }
        return homepage
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
    
    static var loginInfo: [String: String]? {
        get {
            guard let savedData = UserDefaults.standard.data(forKey: "LoginInfo")
            else { return nil }
            let dic = try? JSONSerialization.jsonObject(with: savedData, options: []) as? [String: String]
            
            return dic
        }
        set(val) {
            guard let jsonData = try? JSONEncoder().encode(val) else {
                return
            }
            UserDefaults.standard.setValue(jsonData, forKey: "LoginInfo")
        }
    }
}
