//
//  ContainStoreButtonViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/27.
//

import Foundation
import UIKit

class ContainStoreButtonViewController: UIViewController{
    internal var wineStoreInfo: WineStoreInfo?
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
        
    }
    
    @objc
    private func takePicture() {
        guard let vc = UIStoryboard(name: StoryBoard.readWine.name, bundle: nil).instantiateViewController(withIdentifier: AddWineInfomationViewController.identifier) as? AddWineInfomationViewController else { return }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
    }
    
    @objc
    func goToStore() {
        guard let vc = UIStoryboard(name: StoryBoard.store.name, bundle: nil).instantiateViewController(withIdentifier: StoreInfoViewController.identifier) as? StoreInfoViewController else { return }
        vc.wineStoreInfo = wineStoreInfo
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc
    func close() {
        self.dismiss(animated: true)
    }
}
