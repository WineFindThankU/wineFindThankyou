//
//  MyPageViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/31.
//

import Foundation
import UIKit

class MyPageViewController : UIViewController{
    private weak var topView: TopView?
    @IBOutlet private weak var myProfileView: UIView!
    @IBOutlet private weak var lineView: UIView!
    @IBOutlet private weak var wineCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        let topView = setTopView(self.view, height: 44)
        topView.leftButton?.setBackgroundImage(UIImage(named: "leftArrow"), for: .normal)
        topView.rightButton?.setBackgroundImage(UIImage(named: "settings"), for: .normal)
        topView.leftButton?.addTarget(self, action: #selector(close), for: .touchUpInside)
        topView.rightButton?.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)
        topView.titleLabel?.text = "마이페이지"
        topView.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        self.topView = topView
        
        lineView.backgroundColor = Theme.gray.color
    }
    
    @objc
    private func close() {
        self.dismiss(animated: true)
    }
    @objc
    private func goToSettings() {
        guard let vc = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else { return }
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}
