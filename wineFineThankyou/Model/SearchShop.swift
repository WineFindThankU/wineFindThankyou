//
//  SearchShop.swift
//  wineFindThankyou
//
//  Created by suding on 2022/03/10.
//

import Foundation

// MARK: - SearchShop
struct SearchShop: Codable {
    let statusCode: Int
    let message: String
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let sh_no, sh_name: String
    let sh_category: ShCategory
    let sh_address: String
    let sh_tell: String?
    let sh_url: String?
    let sh_latitude, sh_longitude: Double
}

enum ShCategory: String, Codable {
    case chain = "CHAIN"
    case department = "DEPARTMENT"
    case etc = "ETC"
    case shCategoryCONVENIENCE = "CONVENIENCE"
    case shCategoryPRIVATE = "PRIVATE"
    case supermarket = "SUPERMARKET"
}
