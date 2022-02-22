//
//  LocationError.swift
//  wineFindThankyou
//
//  Created by suding on 2022/02/22.
//

import Foundation

enum LocationError: LocalizedError {
    
    case denied
    case unknown
    case unknownLocation
    case disableLocationService
    
    var localizedDescription: String {
        switch self {
        case .denied:
            return "거절되었습니다."
        case .unknown:
            return "알 수 없는 오류 입니다."
        case .unknownLocation:
            return "장소가 없습니다."
        case .disableLocationService:
            return "해당 서비스를 이용할 수 없습니다."
        }
    }
}
