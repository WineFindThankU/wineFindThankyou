//
//  HTTPHeaderField.swift
//  wineFindThankyou
//
//  Created by suding on 2022/02/27.
//

import Foundation
import Alamofire

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
}

enum ContentType: String {
    case json = "Application/json"
}
