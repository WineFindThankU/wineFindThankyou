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
    @IBOutlet weak var leftStatisticsView: UIView!
    @IBOutlet weak var rightStatisticsView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        setUpTopView()
        setWelcomeView()
        setGraphView()
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

//topView
extension MyPageViewController {
    private func setUpTopView() {
        let topView = setTopView(self.view, height: 44)
        topView.leftButton?.setBackgroundImage(UIImage(named: "leftArrow"), for: .normal)
        topView.rightButton?.setBackgroundImage(UIImage(named: "settings"), for: .normal)
        topView.leftButton?.addTarget(self, action: #selector(close), for: .touchUpInside)
        topView.rightButton?.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)
        topView.titleLabel?.text = "마이페이지"
        topView.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        self.topView = topView
    }
    
    private func setWelcomeView() {
        let welcomeView = WelcomeView()
        self.myProfileView.addSubview(welcomeView)
        welcomeView.configure(superView: myProfileView)
        welcomeView.userInfo = UserInfo(userImage: UIImage(named: "TestUserImage")!, userType: "와린이", wineType: "로제", userId: "guest412")
    }
    
    private func setGraphView() {
        let leftGraphView = StatisticsOfWineView(frame: CGRect(x: 0, y: 0, width: leftStatisticsView.frame.width, height: leftStatisticsView.frame.height))
        let rightGraphView = StatisticsOfWineView(frame: CGRect(x: 0, y: 0, width: rightStatisticsView.frame.width, height: rightStatisticsView.frame.height))
        leftStatisticsView.addSubview(leftGraphView)
        rightStatisticsView.addSubview(rightGraphView)
        leftGraphView.graphResource = GraphResource(type: .shop, cntArr: [10, 9, 5, 4, 3, 3])
        rightGraphView.graphResource = GraphResource(type: .bought, cntArr: [10, 9, 5, 4, 3])
    }
}
//profileView

//tableView

extension String {
    func rangeBoldString(_ size: CGFloat, range: String) -> NSMutableAttributedString {
        let bold = UIFont.boldSystemFont(ofSize: size)
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(.font, value: bold, range: (self as NSString).range(of: range))
        return attributedString
    }
    func rangeSizeUp(_ size: CGFloat, font: UIFont.Weight = .regular, range: String) -> NSMutableAttributedString {
        let bold = UIFont.systemFont(ofSize: size, weight: font)
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(.font, value: bold, range: (self as NSString).range(of: range))
        return attributedString
    }
}
