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
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let accessToken, refreshToken: String
}
