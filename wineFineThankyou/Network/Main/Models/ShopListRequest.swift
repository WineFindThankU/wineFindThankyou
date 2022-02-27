//
//  ShopListRequest.swift
//  wineFindThankyou
//
//  Created by suding on 2022/02/27.
//

import Foundation

struct Shop: Encodable {
    let type: String
    let longtitude: Double
    let latitude: Double
    let category: String
    let radius: Int
}
