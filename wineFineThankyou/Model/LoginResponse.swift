//
//  LoginResponse.swift
//  wineFindThankyou
//
//  Created by suding on 2022/03/01.
//

import Foundation

// MARK: - Login
struct LoginResponse: Codable {
    let statusCode: Int
    let message: String
    var data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let accessToken, refreshToken: String
}

struct SignResponse: Codable {
    let statusCode: Int
    let error: [String]
    var message: String
}
