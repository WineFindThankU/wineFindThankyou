//
//  TestData.swift
//  wineFindThankyou
//
//  Created by mun on 2022/03/09.
//

import Foundation
import UIKit

//MARK: 문용. 테스트 데이터 추후 삭제예정
func loadTestDatas() -> [WineInfo] {
    guard let img = UIImage(named: "TestWineImg") else { return [] }
    
    var wineInfos = [WineInfo]()
    (0 ... 9).forEach {
        let type = StoreType.allOfCases.randomElement() ?? .privateShop
        let wineStoreInfo = WineStoreInfo(key: $0,
                                          storeName: "\($0)+벵가드와인머천트 분당지점",
                                          classification: type,
                                          callNumber: "010-1111-2222",
                                          location: "경기도 성남시 분당구 서현이매분당동 241-5",
                                          openingHours: "AM07:00 - PM11:00",
                                          homepage: "https://wineFindThankYou.kr")
        
        let wineInfo = WineInfo(img: img,
                                korName: "비카스 초이스 소비뇽 블랑 스파클링",
                                engName: "Vicar's Choice Sauvignon Blanc Bubbles",
                                wineType: WineType.sparkling,
                                cepage: "소비뇽 블랑 (Sauvignon Blanc)",
                                from: "뉴질랜드",
                                vintage: "2010",
                                alchol: "Alc. 15%", storeFk: wineStoreInfo.key, boughtDate: Date())
        let wineInfo2 = WineInfo(img: img,
                                 korName: "젠틀 타이거 화이트",
                                 engName: "Gentle Tiger White",
                                 wineType: WineType.white,
                                 cepage: "샤르도네 (Chardonnay), 비우라 (Viura)",
                                 from: "뉴질랜드",
                                 vintage: "2010",
                                 alchol: "Alc. 15%", storeFk: wineStoreInfo.key, boughtDate: Date(timeInterval: TimeInterval(-86400 * $0), since: Date()))
        let wineInfo3 = WineInfo(img: img,
                                 korName: "카피텔 산 로코 발폴리첼라 리파쏘 수페리오레",
                                 engName: "Capitel San Rocco Valpolicella Ripasso Superiore",
                                 wineType: WineType.red,
                                 cepage: "코르비나(Corvina), 코르비노네(Corvinone), 론디넬라(Rondinella), 기타(Others)",
                                 from: "아르헨티나",
                                 vintage: "2010",
                                 alchol: "Alc. 15%", storeFk: wineStoreInfo.key, boughtDate: Date(timeInterval: TimeInterval(-86400 * 10 - $0), since: Date()))
        let wineInfo4 = WineInfo(img: img,
                                 korName: "젠틀 타이거 레드",
                                 engName: "Gentle Tiger Red",
                                 wineType: WineType.red,
                                 cepage: "샤르도네 (Chardonnay)",
                                 from: "뉴질랜드",
                                 vintage: "2010",
                                 alchol: "Alc. 13%", storeFk: wineStoreInfo.key, boughtDate: Date(timeInterval: TimeInterval(-86400 * 7 - $0), since: Date()))
        
        if $0 % 5 == 0 {
            wineInfos.append(wineInfo)
        }
        wineInfos.append(wineInfo2)
        if $0 % 2 == 0 {
            wineInfos.append(wineInfo3)
            wineInfos.append(wineInfo4)
        }
    }
    
    return wineInfos
}
