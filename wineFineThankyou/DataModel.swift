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

class WineInfo {
    let key: String
    let name: String
    let wine: Wine?
    let img: UIImage?
    init(_ params: JSON) {
        self.key = params["uw_no"].string ?? ""     //"cl0m224l61633om62y0axupke",
        self.name = params["uw_name"].string ?? ""   //"",
        self.wine = Wine(params)
        guard let data = try? params["wn_img"].rawData(),
              let img = UIImage(data: data)
        else { self.img = nil; return }
        
        self.img = img
    }
}

class Wine {
    let key: String
    let korName: String
    let engName: String
    let brand: String
    let cepage: String
    let nation: String
    let from: String
    let alcohol: String
    let vintage: String
    let boughtDate: Date?
    let type: WineType
    init(_ params: JSON) {
        self.key = params["wn_no"].string ?? ""  //"cl096cov5105131m0lg1rerzp"
        self.korName = params["wn_name"].string ?? ""       //"콘트라토, 블랑 드 블랑",
        self.engName = params["wn_name_en"].string ?? ""  //"Contratto, Blanc de Blanc",
        self.brand = params["wn_brand"].string ?? ""      //"콘트라또 Contratto",
        self.cepage = params["wn_kind"].string ?? ""   //"샤르도네 (Chardonnay) 100%",
        self.nation = params["wn_nation"].string ?? ""    //"피에몬테(Piemonte)",
        self.from = params["wn_country"].string ?? ""     //"이탈리아(Italy)",
        self.alcohol = params["wn_alcohol"].string ?? ""  //"12~13 %",
        self.vintage = params["wn_vintage"].string ?? ""
        if let dateStr = params["purchased_at"].string {
            self.boughtDate = DateFormatter().date(from: dateStr)
        } else {
            self.boughtDate = nil
        }
        
        let typeStr = params["wn_category"].string ?? WineType.red.str
        self.type = WineType.allCases.first(where: {$0.str == typeStr}) ?? WineType.red
    }
}
//    let summary: WineSummary
//    let engName: String
//    let wineType: WineType
//    let kind: String
//    let from: String
//    let vintage: String
//    let alchol: String
//    let boughtDate: Date
//    init(_ params: [JSON]) {
//        let key = params["wn_no"].string ?? ""
//        let korName = params["wn_name"].string ?? ""
//        let engName = params["wn_name_en"].string ?? ""
//        let kind = params["wn_kind"].string ?? ""
//        let country = params["wn_country"].string ?? ""
//        let alchol = params["wn_alcohol"].string ?? ""
//        let imgData = params["wn_img"].rawData()
//        let category = params["wn_category"].string ?? ""
//
//    }
//}

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
    private let address: String?
    private let name: String?
    private let tellNumber: String?
    private var bookmark: Bool
    let type: ShopType
    let latitude: Double
    let longtitude: Double
    var userWines = [WineInfo]()
    init(_ param: JSON) {
        self.key = param["sh_no"].string ?? ""
        self.homepage = param["sh_url"].string
        self.bookmark = param["sh_bookmark"].bool ?? false
        self.address = param["sh_address"].string
        self.name = param["sh_name"].string
        self.tellNumber = param["sh_tell"].string
        self.latitude = param["sh_latitude"].double ?? 0.0
        self.longtitude = param["sh_longitude"].double ?? 0.0
        
        let typeStr = param["sh_category"].string ?? ShopType.privateShop.typeStr
        self.type = ShopType.allOfCases.first(where: {$0.typeStr == typeStr}) ?? .privateShop
        
        self.userWines = param["userWines"].array?.compactMap { WineInfo($0["wine"]) } ?? []
    }
    
    var isBookmarked: Bool {
        get {
            return self.bookmark
        } set(val) {
            self.bookmark = val
        }
    }
    
    var imgName: String {
        switch type {
        case .all:
            return ""
        case .privateShop:
            return "privateShop"
        case .warehouse:
            return "warehouse"
        case .mart:
            return "mart"
        case .convenience:
            return "convenience"
        case .chain:
            return "chain"
        case .department:
            return "department"
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

struct FavoriteShop {
    let wineCnt: Int
    let shopSummary: ShopSummary
    let isBookmark: Bool
}

struct ShopSummary {
    let key: String
    let name: String
    let categoryType: String
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
