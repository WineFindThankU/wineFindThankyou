//
//  ExtString.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/29.
//

import Foundation

struct UserData {
    let isUserLoginBefore = "isUserLoginBefore"
    static var IsUserLogin : Bool {
        return UserDefaults.standard.bool(forKey: "isUserLoginBefore")
    }
}
