//
//  ShopContainedButtonViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/27.
//

import Foundation
import UIKit

class ShopContainedButtonViewController: UIViewController{
    enum MapType {
        case naver
        case kakao
    }
    var shop: Shop!
    var wineInfos: [WineInfo] = []
    internal unowned var shopButtonsView: ShopButtonsView! {
        didSet { addTargetOnButton() }
    }
    
    func addTargetOnButton(){
        shopButtonsView?.left?.btn.addTarget(self, action: #selector(addFavorites), for: .touchUpInside)
        shopButtonsView?.middle?.btn.addTarget(self, action: #selector(findRoad), for: .touchUpInside)
        shopButtonsView?.right?.btn.addTarget(self, action: #selector(takePicture), for: .touchUpInside)
    }
    
    @objc
    private func addFavorites() {
        print("munyong > self.shopInfo.key: \(self.shop.key)")
        AFHandler.addFavoriteShop(self.shop.key) {
            print("munyong > \($0)")
        }
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
                mapUrlString = "navermaps://?menu=route&routeType=4&elat=\(shop.latitude)&elng=\(shop.longtitude)&etitle=\(shop.nnName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                safariUrlString = "http://itunes.apple.com/app/id311867728?mt=8"
                
            case .kakao:
                mapUrlString = "kakaomap://search?q=\(shop.nnName)&p=\(shop.latitude),\(shop.longtitude)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                safariUrlString = "https://map.kakao.com/link/to/\(shop.nnName),\(shop.latitude),\(shop.longtitude)"
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
        vc.shop = shop
        self.present(vc, animated: false)
    }
    
    @objc
    func goToShop() {
        guard let vc = UIStoryboard(name: StoryBoard.shop.name, bundle: nil).instantiateViewController(withIdentifier: ShopInfoViewController.identifier) as? ShopInfoViewController
        else { return }
        
        vc.wineInfos = wineInfos
        vc.shop = self.shop
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc
    func close() {
        self.dismiss(animated: true)
    }
}
