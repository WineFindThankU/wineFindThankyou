//
//  Logout.swift
//  wineFindThankyou
//
//  Created by suding on 2022/03/07.
//

import Foundation

// MARK: - Logout
struct Logout: Codable {
    let statusCode: Int
    let error, message: String
}

// MARK: - 회원탈퇴
struct Leave: Codable {
    let statusCode: Int
    let error, message: String
}
