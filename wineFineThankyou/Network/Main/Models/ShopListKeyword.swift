//
//  ShopListKeyword.swift
//  wineFindThankyou
//
//  Created by suding on 2022/02/27.
//

import Foundation

enum ShopListKeywordModel
{
    struct Request
    {
        var type: String
        var keyword: String
    }
    struct Response
    {
        var response: [ShopListKeywordResponse]
    }
    struct ViewModel
    {
        var result: Bool
    }
}

struct ShopListKeywordResponse: Decodable {
    var sh_no: String?
    var sh_name: String?
    var sh_category: String?
    var sh_address: String?
    var sh_tell: String?
    var sh_url: String?
}
