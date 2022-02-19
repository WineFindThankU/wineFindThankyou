//
//  Calculator.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/19.
//

import Foundation
class Calculator {
    class func fromIntToPercent(_ values: [Int]) -> [Double]{
        let total = values.reduce(0, +)
        print("total: \(total)")
        print("values: \(values.compactMap { Double($0) / Double(total) })")
        return values.compactMap { Double($0) / Double(total) }
    }
}
