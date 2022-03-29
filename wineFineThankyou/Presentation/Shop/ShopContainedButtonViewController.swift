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
    internal unowned var shopBtnsView: ShopButtonsView! {
        didSet { addTargetOnButton() }
    }
    
    func addTargetOnButton(){
        shopBtnsView?.left?.btn.addTarget(self, action: #selector(addFavorites), for: .touchUpInside)
        shopBtnsView?.middle?.btn.addTarget(self, action: #selector(findRoad), for: .touchUpInside)
        shopBtnsView?.right?.btn.addTarget(self, action: #selector(takePicture), for: .touchUpInside)
        setBookmarkedBtn()
    }
    
    func setBookmarkedBtn() {
        let imgName = self.shop.isBookmarked ? "favorites_on" : "favorites_off"
        DispatchQueue.main.async {
            self.shopBtnsView.left?.img.image = UIImage(named: imgName)
        }
    }
    
    @objc
    private func addFavorites() {
        AFHandler.addFavoriteShop(self.shop.key, !self.shop.isBookmarked) { isSuccess in
            guard isSuccess else { noticeResponseFail(); return }
            self.shop.isBookmarked = !self.shop.isBookmarked
            self.setBookmarkedBtn()
        }
        
        func noticeResponseFail() {
            let alert = UIAlertController(title: "오류",
                                          message: "알 수 없는 이유로 즐겨찾기 등록에 실패하였습니다. 다시 시도해주세요.",
                                          preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(ok)
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
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
        if let summaryVC = self as? ShopInfoSummaryViewController {
            vc.delegate = summaryVC
        }
        self.present(vc, animated: false)
    }
    
    @objc
    func goToShop() {
        guard let vc = UIStoryboard(name: StoryBoard.shop.name, bundle: nil).instantiateViewController(withIdentifier: ShopInfoViewController.identifier) as? ShopInfoViewController
        else { return }
        
        vc.shop = self.shop
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc
    func close() {
        self.dismiss(animated: true, completion: {
            guard let top = topViewController() else { return }
            if let summaryVC = top as? ShopInfoSummaryViewController {
                summaryVC.shop = self.shop
                summaryVC.setBookmarkedBtn()
            } else if let mainVC = top as? MainViewController {
                mainVC.showShopsAtCrntLoc()
            }
        })
    }
}
