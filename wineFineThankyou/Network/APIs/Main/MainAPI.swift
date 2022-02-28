//
//  MainAPI.swift
//  wineFindThankyou
//
//  Created by suding on 2022/02/28.
//

import Foundation
import Alamofire

struct MainAPI {
    static func getShopList(request: ShopListModel.Request,
                            completion: @escaping (_ succeed: ShopList?,
                                                   _ failed: Error?) -> Void) {
        AF.request(MainAPITarget.shopList(request))
            .responseDecodable { (response: AFDataResponse<ShopListModel.Response>) in
                switch response.result {
                case .success(let response):
               //     completion(ShopListModel.Response, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }

}
