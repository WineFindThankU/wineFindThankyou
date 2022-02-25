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
    var visitedWineStoreInfos = [WineStoreInfo]()
    var favoritesWineStoreInfos = [WineStoreInfo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setTouchGesture()
        
        //MARK: Test
        wineInfos = getWines()
        visitedWineStoreInfos = getWineStoreInfo()
        favoritesWineStoreInfos = getWineStoreInfo()
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
        guard let vc = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else { return }
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
        leftGraphView.graphResource = GraphResource(type: .shop, cntArr: [10, 9, 5, 4, 3, 3])
        rightGraphView.graphResource = GraphResource(type: .bought, cntArr: [10, 9, 5, 4, 3])
    }
    
    private func goToNextStep(_ type: MypageTableViewSection) {
        let storyBoard = UIStoryboard(name: "MyPage", bundle: nil)
        switch type {
        case .recentlyBoughtWine:
            guard let vc = storyBoard.instantiateViewController(withIdentifier: "BoughtWineListViewController") as? BoughtWineListViewController
            else { return }
            vc.wineInfos = self.wineInfos
            presentVc(vc)
        case .recentlyVisitedShop, .favoriteShop:
            guard let vc = storyBoard.instantiateViewController(withIdentifier: "UsersWineShopListViewController") as? UsersWineShopListViewController
            else { return }
            vc.wineStoreInfos = type == .recentlyVisitedShop ? self.visitedWineStoreInfos : self.favoritesWineStoreInfos
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
        tableView.estimatedRowHeight = 227
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print(MypageTableViewSection.allCases.count)
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
            cell.cellInfos = type == .recentlyVisitedShop ? self.visitedWineStoreInfos : self.favoritesWineStoreInfos
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
        print(scrollView.contentOffset.y)
        if Int(scrollView.contentOffset.y) <= 0 {
            showMyProfileView()
        }
    }
}

extension MyPageViewController {
    //MARK: TEST
    private func getWines() -> [WineInfo] {
        guard let img = UIImage(named: "TestWineImg") else { return [] }
    
        var wineInfos = [WineInfo]()
        wineInfos.append(
            WineInfo(img: img,
                     korName: "비카스 초이스 소비뇽 블랑 스파클링",
                     engName: "Vicar's Choice Sauvignon Blanc Bubbles",
                     wineType: WineType.sparkling,
                     cepage: "소비뇽 블랑 (Sauvignon Blanc)",
                     from: "뉴질랜드",
                     vintage: "2010",
                     alchol: "Alc. 15%")
        )
        
        wineInfos.append(
            WineInfo(img: img,
                     korName: "카피텔 산 로코 발폴리첼라 리파쏘 수페리오레",
                     engName: "Capitel San Rocco Valpolicella Ripasso Superiore",
                     wineType: WineType.red,
                     cepage: "코르비나(Corvina), 코르비노네(Corvinone), 론디넬라(Rondinella), 기타(Others)",
                     from: "아르헨티나",
                     vintage: "2010",
                     alchol: "Alc. 15%")
        )
        
        wineInfos.append(
            WineInfo(img: img,
                     korName: "젠틀 타이거 화이트",
                     engName: "Gentle Tiger White",
                     wineType: WineType.white,
                     cepage: "샤르도네 (Chardonnay), 비우라 (Viura)",
                     from: "뉴질랜드",
                     vintage: "2010",
                     alchol: "Alc. 15%")
        )
        
        return wineInfos
    }
    
    func getWineStoreInfo() -> [WineStoreInfo] {
        
        return [  WineStoreInfo(storeName: "벵가드와인머천트 분당지점",
                                classification: .privateShop,
                                callNumber: "010-1111-2222", location: "경기도 성남시 분당구 서현이매분당동 241-5",
                                openingHours: "AM07:00 - PM11:00", homepage: "https://wineFindThankYou.kr",
                                wines: []),
                  WineStoreInfo(storeName: "벵가드와인머천트 분당지점",
                                                     classification: .privateShop,
                                                     callNumber: "010-1111-2222", location: "경기도 성남시 분당구 서현이매분당동 241-5",
                                                     openingHours: "AM07:00 - PM11:00", homepage: "https://wineFindThankYou.kr",
                                                     wines: []),
                  WineStoreInfo(storeName: "벵가드와인머천트 분당지점",
                                                     classification: .privateShop,
                                                     callNumber: "010-1111-2222", location: "경기도 성남시 분당구 서현이매분당동 241-5",
                                                     openingHours: "AM07:00 - PM11:00", homepage: "https://wineFindThankYou.kr",
                                                     wines: []),
                  WineStoreInfo(storeName: "벵가드와인머천트 분당지점",
                                                     classification: .privateShop,
                                                     callNumber: "010-1111-2222", location: "경기도 성남시 분당구 서현이매분당동 241-5",
                                                     openingHours: "AM07:00 - PM11:00", homepage: "https://wineFindThankYou.kr",
                                                     wines: []),
                  WineStoreInfo(storeName: "벵가드와인머천트 분당지점",
                                                     classification: .privateShop,
                                                     callNumber: "010-1111-2222", location: "경기도 성남시 분당구 서현이매분당동 241-5",
                                                     openingHours: "AM07:00 - PM11:00", homepage: "https://wineFindThankYou.kr",
                                                     wines: [])]
    }
}
