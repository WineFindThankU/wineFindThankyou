//
//  ShopListResponse.swift
//  wineFindThankyou
//
//  Created by suding on 2022/02/27.
//

import Foundation

enum ShopListModel
{
    struct Request: Decodable
    {
        var statusCode: String
        var message: String
    }
    struct Response: Decodable
    {
        var response: [ShopListResponse]
    }
    struct ViewModel: Decodable
    {
        var result: Bool
    }
}

struct ShopListResponse: Decodable {
    var sh_no: String?
    var sh_name: String?
    var sh_category: String?
    var sh_address: String?
    var sh_tell: String?
    var sh_url: String?
}
