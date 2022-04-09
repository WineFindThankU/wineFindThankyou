//
//  Model+Wine.swift
//  wineFindThankyou
//
//  Created by mun on 2022/03/19.
//

import Foundation
import SwiftyJSON

class BoughtWine {
    let wineInfo: WineInfo?
    let from: String
    let vintage: String
    let date: String
    let shopDetail: ShopDetail?
    
    init(_ param: JSON) {
        self.wineInfo = WineInfo(param)
        self.from = param["uw_country"].string ?? ""
        self.vintage = param["uw_vintage"].string ?? ""
        self.date = param["purchased_at"].string ?? ""
        self.shopDetail = ShopDetail(param["shop"])
    }
    
    var name: String? {
        return self.wineInfo?.wineAtServer?.korName ?? self.wineInfo?.nnKorName
    }
}

class WineInfo {
    let key: String
    let vintage: String
    private let name: String
    private let userWineFrom: String
    let wineAtServer: WineAtServer?
    init(_ params: JSON) {
        self.key = params["uw_no"].string ?? ""     //"cl0m224l61633om62y0axupke",
        self.name = params["uw_name"].string ?? ""   //"",
        self.vintage = params["uw_vintage"].string ?? ""
        self.userWineFrom = params["uw_country"].string ?? ""
        self.wineAtServer = WineAtServer(params["wine"])
    }
    
    var nnKorName: String {
        guard let korName = wineAtServer?.korName, !korName.isEmpty
        else { return name}
        return korName
    }
    
    var nnFrom: String {
        guard let from = wineAtServer?.from, !from.isEmpty
        else { return userWineFrom }
        return from
    }
}

class WineAtServer {
    var key: String
    var korName: String
    var engName: String
    var brand: String
    var cepage: String
    var from: String
    var alcohol: String
    var type: WineType?
    var imgUrlStr: String?
    
    init() {
        self.key = ""
        self.korName = ""
        self.engName = ""
        self.brand = ""
        self.cepage = ""
        self.from = ""
        self.alcohol = ""
        self.type = nil
        self.imgUrlStr = nil
    }
    
    init(_ data: JSON) {
        self.key = data["wn_no"].string ?? ""
        self.korName = data["wn_name"].string ?? ""
        self.engName = data["wn_name_en"].string ?? ""
        self.brand = data["wn_brand"].string ?? ""
        self.cepage = data["wn_kind"].string ?? ""
        self.from = data["wn_country"].string ?? ""
        self.alcohol = data["wn_alcohol"].string ?? ""
        self.type = WineType.allCases.first { $0.str == data["wn_category"].string }
        self.imgUrlStr = data["wn_img"].string ?? nil
    }
}
