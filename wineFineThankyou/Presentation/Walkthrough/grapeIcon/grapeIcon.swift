//
//  grapeIcon.swift
//  wineFindThankyou
//
//  Created by suding on 2022/03/07.
//

import Foundation
import UIKit

enum GrapeCase {
    case costGrape
    case dionysusGrape
    case analystGrape
    case artistGrape
    case childGrape
    
    var str: String {
        switch self {
        case .costGrape:
            return "가성비 포도알"
        case .dionysusGrape:
            return "디오니소스 포도알"
        case .analystGrape:
            return "분석가 포도알"
        case .artistGrape:
            return "예술가 포도알"
        case .childGrape:
            return "와린이 포도알"
        }
    }
    
    var grapeImage: UIImage {
        switch self {
        case .costGrape:
            return UIImage(named: "costGrape")!
        case .dionysusGrape:
            return UIImage(named: "dionysusGrape")!
        case .analystGrape:
            return UIImage(named: "analystGrape")!
        case .artistGrape:
            return UIImage(named: "artistGrape")!
        case .childGrape:
            return UIImage(named: "childGrape")!
        }
    }
}

/*
     1) 포도알 캐릭터 6개 중 1개 노출 :
      -Q1.“가성비” 선택시 —> 가성비 포도알
      -Q1. “포도 품종 or 와인 브랜드 or 생산 지역” 선택시 —> 예술가 포도알
      —Q1. “와인 종류” or “기타” 선택시, Q2 선택에 캐릭터 배정권 부여
      -Q2.“2만원 이하” or “3~4만원” 선택시 —> 가성비 포도알
      -Q2. “퀄리티가 된다면 가격은 상관없어요!” 선택시 —> 예술가 포도알
      —Q2. “5~7만원“, “8~10만원” 선택시,Q3 선택에 캐릭터 배정권 부여
      -Q3. “모임/파티를 위해서” or “내가 마시려고” 선택시 —> 디오니소스 포도알
      -Q3. “선물하려고” 선택시 —> 와린이 포도알
      -Q1&Q3 모두 “기타” 선택시 —> 분석가 포도알
 */

class grapeIcon {

}
