//
//  AFHandler+Wine.swift
//  wineFindThankyou
//
//  Created by mun on 2022/03/19.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

extension AFHandler {
    class func searchWine(byKeyword: String, done:(([WineAtServer]) -> Void)?) {
        guard !byKeyword.isEmpty else { done?([]); return }
        let url = "http://125.6.36.157:3001/v1/wine"
        let param = ["keyword":byKeyword]
        session.request(url, method: .get, parameters: param, encoding: URLEncoding.default).responseJSON { res in
            switch res.result {
            case .success(let nsDict):
                guard let nsDict = nsDict as? NSDictionary
                else { done?([]); return }
                
                let wineAtServer = JSON(nsDict)["data"].array?.compactMap {
                    WineAtServer($0)
                } ?? []
                
                done?(wineAtServer)
                return
            default:
                done?([]); return
            }
        }
    }
    
    class func getBoughtWine(_ pageNumber: Int, done: (() -> Void)?) {
        let url = "http://125.6.36.157:3001/v1/user/wine"
        let param = ["page":pageNumber]
        session.request(url, method: .get, parameters: param, encoding: URLEncoding.default).responseJSON { res in
            switch res.result {
            case .success(let nsDict):
                guard let nsDict = nsDict as? NSDictionary
                else { done?(); return }
                
                let dict = JSON(nsDict)["data"]
                print(dict)
                done?()
                return
            default:
                done?(); return
            }
        }
    }
    
    class func addWine(_ param: [String: Any], done: ((Bool) -> Void)?) {
        let url = "http://125.6.36.157:3001/v1/wine"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: param, options: [])
        } catch {
            done?(false); return
        }
        
        session.request(request).responseJSON { res in
            switch res.result {
            case .success(let nsDict):
                guard let nsDict = nsDict as? NSDictionary
                else { done?(false); return }
                
                done?(true)
                return
            default:
                done?(false); return
            }
        }
    }
    
    class func deleteWine(_ key: String, done: ((Bool) -> Void)?) {
        let url = "http://125.6.36.157:3001/v1/wine"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: ["uw_no": key], options: [])
        } catch {
            print("http Body Error")
        }
        
        session.request(request).responseJSON { res in
            switch res.result {
            case .success(let nsDict):
                guard let nsDict = nsDict as? NSDictionary
                else { done?(false); return }
                done?(true)
                return
            default:
                done?(false); return
            }
        }
    }
}
