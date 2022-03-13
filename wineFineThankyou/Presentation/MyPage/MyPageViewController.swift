//
//  MyPageViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/31.
//

import Foundation
import UIKit

class MyPageViewController : UIViewController, UIGestureRecognizerDelegate{
    private weak var topView: TopView?
    @IBOutlet private weak var myProfileView: UIView!
    @IBOutlet weak var leftStatisticsView: UIView!
    @IBOutlet weak var rightStatisticsView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var myProfileViewHeight: NSLayoutConstraint!
    var originHeight: CGFloat! = 0
    
    var wineInfos = [WineInfo]()
    var visitedWineShops = [Shop]()
    var favoritesWineShops = [Shop]()
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setTouchGesture()
    }
    
    private func configure() {
        setUpTopView()
        setWelcomeView()
        setGraphView()
        setTableView()
        originHeight = myProfileViewHeight.constant
    }
    
    private func setTouchGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchMyProfileView))
        tapGesture.delegate = self
        self.myProfileView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func touchMyProfileView() {
        myProfileViewHeight.constant < originHeight ? showMyProfileView() : hiddenMyProfileView()
    }
    
    private func showMyProfileView() {
        UIView.animate(withDuration: 0.5) {
            self.myProfileViewHeight.constant = self.originHeight
            self.view.layoutIfNeeded()
        }
    }
    
    private func hiddenMyProfileView() {
        UIView.animate(withDuration: 0.5) {
            self.myProfileViewHeight.constant = 137
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    private func close() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func goToSettings() {
        guard let vc = UIStoryboard(name: StoryBoard.myPage.name, bundle: nil).instantiateViewController(withIdentifier: SettingsViewController.identifier) as? SettingsViewController
        else { return }
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}

//profileView
extension MyPageViewController {
    private func setUpTopView() {
        let topView = getGlobalTopView(self.view, height: 44)
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
        leftGraphView.graphResource = GraphResource(type: .shop, cntArr: getShopsByType())
        rightGraphView.graphResource = GraphResource(type: .bought, cntArr: getBoughtWine())
        
        func getShopsByType() -> [Int] {
            var wineShopCount = [Int]()
            ShopType.allOfCases.forEach { type in
                wineShopCount.append(visitedWineShops.filter { $0.type == type}.count)
            }
            return wineShopCount
        }
        
        func getBoughtWine() -> [Int] {
            var wines = [Int]()
            WineType.allCases.forEach { type in
                wines.append(wineInfos.compactMap { $0.wineType }.filter { $0 == type }.count)
            }
            return wines
        }
    }
    
    private func goToNextStep(_ type: MypageTableViewSection) {
        let storyBoard = UIStoryboard(name: StoryBoard.myPage.name, bundle: nil)
        switch type {
        case .recentlyBoughtWine:
            guard let vc = storyBoard.instantiateViewController(withIdentifier: BoughtWineListViewController.identifier) as? BoughtWineListViewController
            else { return }
            vc.wineInfos = self.wineInfos
            vc.shops = self.visitedWineShops
            presentVc(vc)
        case .recentlyVisitedShop, .favoriteShop:
            guard let vc = storyBoard.instantiateViewController(withIdentifier: UsersWineShopListViewController.identifier) as? UsersWineShopListViewController
            else { return }
            vc.wineInfos = wineInfos
            vc.shops = type == .recentlyVisitedShop ? self.visitedWineShops : self.favoritesWineShops
            presentVc(vc)
        }
        
        func presentVc(_ vc: UIViewController) {
            DispatchQueue.main.async {
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .flipHorizontal
                self.present(vc, animated: true)
            }
        }
    }
}


//tableView
extension MyPageViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    private func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "MyPageTableViewCell", bundle: nil), forCellReuseIdentifier: "MyPageTableViewCell")
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MypageTableViewSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageTableViewCell")
                as? MyPageTableViewCell,
              let type = MypageTableViewSection(rawValue: indexPath.section)
        else { return UITableViewCell() }
        
        cell.sectionType = MypageTableViewSection(rawValue: indexPath.section) ?? MypageTableViewSection.recentlyBoughtWine
        
        if type == .recentlyBoughtWine {
            cell.cellInfos = self.wineInfos
        } else {
            cell.cellInfos = type == .recentlyVisitedShop ? self.visitedWineShops : self.favoritesWineShops
        }
        cell.touchRightBtn = { [weak self] in
            self?.goToNextStep(type)
        }
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        hiddenMyProfileView()
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        showMyProfileView()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if Int(scrollView.contentOffset.y) <= 0 {
            showMyProfileView()
        }
    }
}
