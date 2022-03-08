//
//  ContainStoreButtonViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/27.
//

import Foundation
import UIKit

class ContainStoreButtonViewController: UIViewController{
    enum MapType {
        case naver
        case kakao
    }
    var shopInfo: ShopInfo!
    var wineInfos: [WineInfo] = []
    internal unowned var storeButtonsView: StoreButtonsView! {
        didSet { addTargetOnButton() }
    }
    
    func addTargetOnButton(){
        storeButtonsView?.left?.btn.addTarget(self, action: #selector(addFavorites), for: .touchUpInside)
        storeButtonsView?.middle?.btn.addTarget(self, action: #selector(findRoad), for: .touchUpInside)
        storeButtonsView?.right?.btn.addTarget(self, action: #selector(takePicture), for: .touchUpInside)
    }
    
    @objc
    private func addFavorites() {
        
    }
    
    @objc
    private func findRoad() {
        let alert = UIAlertController(title: "길 찾기", message: "원하시는 지도를 선택해주세요.", preferredStyle: .actionSheet)
        let naverMap = UIAlertAction(title: "네이버 지도", style: .default) { _ in
            goToMapsApp(byType: .naver)
        }
        let kakaoMap = UIAlertAction(title: "카카오 지도", style: .default) { _ in
            goToMapsApp(byType: .kakao)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel) { _ in }
        alert.addAction(naverMap)
        alert.addAction(kakaoMap)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)

        func goToMapsApp(byType: MapType) {
            let mapUrlString: String?
            let safariUrlString: String?
            switch byType {
            case .naver:
                mapUrlString = "navermaps://?menu=route&routeType=4&elat=\(shopInfo.latitude)&elng=\(shopInfo.longtitude)&etitle=\(shopInfo.nnName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                safariUrlString = "http://itunes.apple.com/app/id311867728?mt=8"
                
            case .kakao:
                mapUrlString = "kakaomap://search?q=\(shopInfo.nnName)&p=\(shopInfo.latitude),\(shopInfo.longtitude)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                safariUrlString = "https://map.kakao.com/link/to/\(shopInfo.nnName),\(shopInfo.latitude),\(shopInfo.longtitude)"
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            }
            
            guard let encode = mapUrlString,
                  let url = URL(string: encode) as URL? else { return }
            guard UIApplication.shared.canOpenURL(url) else {
                if let nnSafariUrlStr = safariUrlString, let url = URL(string: nnSafariUrlStr) {
                    UIApplication.shared.open(url, options: [:])
                }
                return
            }
            
            UIApplication.shared.open(url)
        }
    }
    
    @objc
    private func takePicture() {
        guard let vc = UIStoryboard(name: StoryBoard.readWine.name, bundle: nil).instantiateViewController(withIdentifier: AddWineInfomationViewController.identifier) as? AddWineInfomationViewController else { return }
        vc.modalPresentationStyle = .overFullScreen
        vc.shopInfo = shopInfo
        self.present(vc, animated: false)
    }
    
    @objc
    func goToStore() {
        guard let vc = UIStoryboard(name: StoryBoard.store.name, bundle: nil).instantiateViewController(withIdentifier: StoreInfoViewController.identifier) as? StoreInfoViewController else { return }
        vc.wineInfos = wineInfos
        vc.shopInfo = self.shopInfo
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc
    func close() {
        self.dismiss(animated: true)
    }
}
