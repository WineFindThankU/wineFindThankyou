//
//  DataModel.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/29.
//

import Foundation
import UIKit
import SwiftyJSON

struct UsersWineType : Codable {
    let question1 : String
    let question2: String
    let question3: String
}

enum AfterLogin {
    case success
    case fail
    case cannotAccess
    
    //TEST
    var str: String{
        switch self {
        case .success:
            return "로그인 성공"
        case .fail:
            return "로그인 실패"
        case .cannotAccess:
            return "나이가 어려요"
        }
    }
    
    var detail: String {
        switch self {
        case .success:
            return ""
        case .fail:
            return "인증 문제로 로그인 할 수 없습니다. 개발자에게 화를 내주세요."
        case .cannotAccess:
            return "애들은 가라, 애들은 가.🤬"
        }
    }
}

enum StoryBoard: String {
    case launch = "Launch"
    case start = "Start"
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
    
    var typeStr: String {
        switch self {
        case .convenience:
            return "CONVENIENCE"
        case .privateShop:
            return "PRIVATE"
        case .chain:
            return "CHAIN"
        case .mart:
            return "SUPERMARKET"
        case .warehouse:
            return "WAREHOUSE"
        case .department:
            return "DEPARTMENT"
        case .all:
            return "ALL"
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

enum AfterSign {
    case success
    case fail
}

class User {
    let id: String
    let nick: String
    let number: String
    let tasteType: String
    init(_ param: JSON) {
        self.id = param["us_id"].string ?? ""
        let nickAndNum = param["us_nick"].string?.components(separatedBy: "-")
        self.nick = nickAndNum?.first ?? ""
        self.number = nickAndNum?.last ?? ""
        self.tasteType = param["taste_type"].string ?? ""
    }
}

struct MyPageData {
    let user: User
    let boughtWines: [BoughtWine]
    let visitedShops: [VisitedShop]
    let bookmarkedShops: [VisitedShop]
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
    
    static var beforeSearched: String {
        get {
            guard let savedData = UserDefaults.standard.string(forKey: "BeforeSearched")
            else { return "" }
            return savedData
        }
        set(val) {
            guard val != "NULL" else {
                UserDefaults.standard.set("", forKey: "BeforeSearched")
                return
            }
            
            guard let prevSaved = UserDefaults.standard.string(forKey: "BeforeSearched")
            else {
                UserDefaults.standard.set(val, forKey: "BeforeSearched")
                return
            }
            
            var newSavedVal = ""
            Array(Set(prevSaved.components(separatedBy: ","))).forEach {
                newSavedVal += ("," + $0)
            }
            newSavedVal += ("," + val)
            UserDefaults.standard.set(newSavedVal, forKey: "BeforeSearched")
        }
    }
}
