//
//  DataModel+Walkthrough.swift
//  wineFindThankyou
//
//  Created by mun on 2022/04/02.
//

import Foundation

enum QuestionList: Int, CaseIterable {
    case question0 = 0
    case question1
    case question2
    var str: String {
        switch self {
        case .question0:
            return "와인을 마실 때 나에게\n 가장 중요한 것은?"
        case .question1:
            return "내가 일상적으로\n 마시는 와인은 얼마?"
        case .question2:
            return "와인을 주로\n 구입하는 이유는?"
        }
    }
    
    var optionList: [String] {
        switch self {
        case .question0:
            return WhenDoSelect.allCases.compactMap { $0.str }
        case .question1:
            return PriceOfWine.allCases.compactMap { $0.str }
        case .question2:
            return ReasonOfBought.allCases.compactMap { $0.str }
        }
    }
}

enum WhenDoSelect: String, CaseIterable {
    case cost = "가성비"
    case grape = "포도 품종"
    case brand = "와인 브랜드"
    case loc = "생산 지역"
    case type = "와인 종류 (레드/화이트/내추럴 등)"
    case etc = "기타 (직접 입력)"
    var str: String { return self.rawValue }
}

enum PriceOfWine: String, CaseIterable {
    case one2Two = "2만원 이하"
    case thr2Four = "3 ~ 4만원대"
    case five2Seven = "5 ~ 7만원 대"
    case eig2Ten = "8 ~ 10만원 대"
    case quality = "퀄리티가 된다면 가격은 상관없음!"
    var str: String { return self.rawValue }
}

enum ReasonOfBought: String, CaseIterable {
    case forMe = "내가 마시기위해서"
    case forParty = "모임과 파티를 위해서"
    case forPresent = "선물하기 위해서"
    var str: String { return self.rawValue }
}
