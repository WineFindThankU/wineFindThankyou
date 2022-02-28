//
//  MapService.swift
//  wineFindThankyou
//
//  Created by suding on 2022/02/28.
//

import Foundation
import RxSwift
import Alamofire

protocol MapServiceProtocol {
    func getAddressFromLocation(latitude: Double, longitude: Double) -> Observable<String>
}

struct MapService: MapServiceProtocol {
    func getAddressFromLocation(latitude: Double, longitude: Double) -> Observable<String> {
        return Observable.create { observer -> Disposable in
            let urlString = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc"
            let headers: HTTPHeaders = [
                "X-NCP-APIGW-API-KEY-ID": "n19w8fu40u",
                "X-NCP-APIGW-API-KEY": "GqAW3iQfgMebstw7j0L2Z0IzvwGliJSmRrQKmXfG"
            ] as HTTPHeaders
            let parameters: [String: Any] = [
                "request": "coordsToaddr",
                "coords": "\(longitude),\(latitude)",
                "orders": "legalcode,admcode,addr,roadaddr",
                "output": "json"
            ]
            
            AF.request(
                urlString,
                method: .get,
                parameters: parameters,
                headers: headers
            ).responseJSON { response in
                if let value = response.value {
                    if let naverMapResponse: NaverMapResponse = JsonUtils.toJson(object: value) {
                        let address = naverMapResponse.getAddress()
                        
                        observer.onNext(address)
                        observer.onCompleted()
                    } else {
                        let error = CommonError(desc: "데이터를 파싱할 수 없습니다.")
                        
                        observer.onError(error)
                    }
                } else {
                    let error = CommonError(desc: "데이터가 비어있습니다.")
                    
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
