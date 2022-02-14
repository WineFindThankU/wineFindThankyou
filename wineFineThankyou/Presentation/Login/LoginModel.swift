//
//  LoginModel.swift
//  wineFindThankyou
//
//  Created by suding on 2022/02/13.
//

import Foundation

enum Login
{
  // MARK: Use cases
  
  enum LoginCheck
  {
    struct Request
    {
    }
    struct Response
    {
        var statusCode: Int?
        var message: String?
    }
    struct ViewModel
    {
    }
  }
}

