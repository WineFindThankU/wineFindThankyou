//
//  Model+Shop.swift
//  wineFindThankyou
//
//  Created by mun on 2022/03/19.
//

import Foundation
import SwiftyJSON

class ShopDetail {
    let key: String
    let name: String
    let shopType: ShopType
    let url: String
    let time: String
    let imgUrlStr: String?
    init(_ param: JSON) {
        self.key = param["sh_no"].string ?? ""
        self.name = param["sh_name"].string ?? ""
        self.url = param["sh_url"].string ?? ""
        self.time = param["sh_time"].string ?? ""
        let typeStr = param["sh_category"].string ?? ""
        self.shopType = ShopType.allOfCases.first(where:  { $0.typeStr == typeStr }) ?? .privateShop
        self.imgUrlStr = param["sh_img"].string
    }
}

class VisitedShop {
    let bookmark: Bool
    let wineCount: Int
    let shopDetail: ShopDetail?
    init(_ param: JSON) {
        self.bookmark = param["uh_bookmark"].bool ?? false
        self.wineCount = param["uh_wine_cnt"].int ?? 0
        self.shopDetail = ShopDetail(param["shop"])
    }
}

class Shop {
    let key: String
    let homepage: String?
    let address: String?
    let name: String?
    let tellNumber: String?
    var bookmark: Bool
    let type: ShopType?
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
        let lat = param["sh_latitude"].double ?? 0.0
        let lng = param["sh_longitude"].double ?? 0.0
        self.latitude = round(lat * 10000000) / 10000000
        self.longtitude = round(lng * 10000000) / 10000000
        
        let typeStr = param["sh_category"].string ?? ShopType.privateShop.typeStr
        self.type = ShopType.allOfCases.first(where: {$0.typeStr == typeStr})
        self.userWines = param["userWines"].array?.compactMap {
            let wineInfo = WineInfo($0)
            guard let wineServerKey = wineInfo.wineAtServer?.key,
                    !wineServerKey.isEmpty
            else { return nil }
            return wineInfo
        } ?? []
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
        default:
            return ""
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
    
    let cellLabelCharCount = 33 * 2
    var nnAddress: String {
        guard let address = address, !address.isEmpty
        else { return "저장된 주소 없음" }
        return insertEnterAtIdx33(str: address)
    }
    var nnOpeningHours: String {
        return "저장된 영업시간 없음"
    }
    var nnHomepage: String {
        guard let homepage = homepage, !homepage.isEmpty
        else { return "저장된 홈페이지 없음" }

        return insertEnterAtIdx33(str: homepage)
    }
    
    func insertEnterAtIdx33(str: String) -> String {
        var rtnStr = ""
        str.enumerated().forEach{ idx, chr in
            let str = idx == cellLabelCharCount ? "\n" + String(chr) : String(chr)
            rtnStr.append(str)
        }
        return rtnStr
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

