//
//  WinePriceCalculator.swift
//  wineFindThankyou
//
//  Created by mun on 2022/06/17.
//

import Foundation

class WinePriceCalculator {
    enum PriceRange: Int {
        case none = 0
        case one
        case three
        case five
        case seven
        case ten
        var str: String {
            switch self {
            case .none:
                return "가격 정보 없음"
            case .one:
                return "1만원 대"
            case .three:
                return "3만원 대"
            case .five:
                return "5만원 대"
            case .seven:
                return "7만원 대"
            case .ten:
                return "10만원 대"
            }
        }
    }
    
    class func getRange(_ price: Int64) -> String {
        if price < 10000 {
            return PriceRange.none.str
        } else if 10000 <= price, price < 30000 {
            return PriceRange.one.str
        } else if 30000 <= price, price < 50000 {
            return PriceRange.three.str
        } else if 50000 <= price, price < 70000 {
            return PriceRange.five.str
        } else if 70000 <= price, price < 100000 {
            return PriceRange.seven.str
        } else {
            return PriceRange.ten.str
        }
    }
}
