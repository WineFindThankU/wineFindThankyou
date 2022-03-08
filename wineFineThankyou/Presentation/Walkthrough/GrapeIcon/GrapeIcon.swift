//
//  GrapeIcon.swift
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
    case basic
    
    func getGrapeName() -> String {
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
        case .basic:
            return "기본 포도알"
        }
    }
    
    func getImageName() -> String {
        switch self {
        case .costGrape:
            return "costGrape"
        case .dionysusGrape:
            return "dionysusGrape"
        case .analystGrape:
            return "analystGrape"
        case .artistGrape:
            return "artistGrape"
        case .childGrape:
            return "childGrape"
        case .basic:
            return "basic"
        }
    }
}

class GrapeIcon {
    var title = ""
    var icon = ""
    var useChoose = ""
    
    func setupTitle(_ data:[String]) -> String {
        if data[0] == "가성비" || data[1] == "2만원 이하" || data[1] == "3 ~ 4만원대" {
            let cost = GrapeCase.costGrape
            title = cost.getGrapeName()
            return cost.getGrapeName()
        } else if (data[0] == "와인 브랜드" || data[1] == "생산 지역" || data[1] == "포도 품종" || data[1] == "퀄리티가 된다면 가격은 상관없음!") {
            let artist = GrapeCase.artistGrape
            return artist.getGrapeName()
        } else if (data[2] == "모임과 파티를 위해서" || data[2] == "내가 마시기위해서") {
            let artist = GrapeCase.dionysusGrape
            return artist.getGrapeName()
        } else if (data[0] == "기타") {
            let analyst = GrapeCase.analystGrape
            return analyst.getGrapeName()
        } else if (data[2] == "선물하기 위해서") {
            let child = GrapeCase.childGrape
            return child.getGrapeName()
        } else {
            let analyst = GrapeCase.analystGrape
            return analyst.getGrapeName()
        }
    }
    
    func setupImage(_ data:[String]) -> String {
        if data[0] == "가성비" || data[1] == "2만원 이하" || data[1] == "3 ~ 4만원대" {
            let cost = GrapeCase.costGrape
            return cost.getImageName()
        } else if (data[0] == "와인 브랜드" || data[1] == "생산 지역" || data[1] == "포도 품종" || data[1] == "퀄리티가 된다면 가격은 상관없음!") {
            let artist = GrapeCase.artistGrape
            return artist.getImageName()
        } else if (data[2] == "모임과 파티를 위해서" || data[2] == "내가 마시기위해서") {
            let artist = GrapeCase.dionysusGrape
            return artist.getImageName()
        } else if (data[0] == "기타") {
            let analyst = GrapeCase.analystGrape
            return analyst.getImageName()
        } else if (data[2] == "선물하기 위해서") {
            let child = GrapeCase.childGrape
            return child.getImageName()
        } else {
            let analyst = GrapeCase.analystGrape
            return analyst.getImageName()
        }
    }
}

