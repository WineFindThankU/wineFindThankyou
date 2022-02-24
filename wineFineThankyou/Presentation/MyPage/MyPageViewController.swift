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
        
        //MARK: TEST
//
        
        
    }
    
    private func configure() {
        setUpTopView()
        setWelcomeView()
        setGraphView()
        setTableView()
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
}


//tableView
extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    private func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "MyPageTableViewCell", bundle: nil), forCellReuseIdentifier: "MyPageTableViewCell")
        tableView.estimatedRowHeight = 227
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MypageTableViewSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let type = MypageTableViewSection(rawValue: section)
        else { return 0 }
        
        switch type {
        case .recentlyBoughtWine:
            return getWines().count
        case .recentlyVisitedShop, .favoriteShop:
            return getWineShop().count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageTableViewCell") as? MyPageTableViewCell,
              let type = MypageTableViewSection(rawValue: indexPath.section)
        else { return UITableViewCell() }
        
        cell.sectionType = MypageTableViewSection(rawValue: indexPath.row) ?? MypageTableViewSection.recentlyBoughtWine
        
        if type == .recentlyBoughtWine {
            cell.indexPath = indexPath
            cell.cellInfos = getWines()
        } else {
            cell.cellInfos = getWineShop()
        }
        return cell
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
    
    func getWineShop() -> [WineShopInfo] {
        
        return [  WineShopInfo(image: UIImage(named: "TestWineShopImg")!, title: "벵가드 와인머천트 분당점", type: "개인샵"),
                WineShopInfo(image: UIImage(named: "TestWineShopImg")!, title: "머천트 벵가드와인", type: "백화점"),
                WineShopInfo(image: UIImage(named: "TestWineShopImg")!, title: "와인 머천트 벵가드 서현점", type: "개인샵"),
                WineShopInfo(image: UIImage(named: "TestWineShopImg")!, title: "벵가드 와인머천트 분당점", type: "개인샵"),
                WineShopInfo(image: UIImage(named: "TestWineShopImg")!, title: "머천트 벵가드와인", type: "백화점"),
                WineShopInfo(image: UIImage(named: "TestWineShopImg")!, title: "와인 머천트 벵가드 서현점", type: "개인샵"),
                WineShopInfo(image: UIImage(named: "TestWineShopImg")!, title: "벵가드 와인머천트 분당점", type: "개인샵"),
                WineShopInfo(image: UIImage(named: "TestWineShopImg")!, title: "머천트 벵가드와인", type: "백화점"),
                WineShopInfo(image: UIImage(named: "TestWineShopImg")!, title: "와인 머천트 벵가드 서현점", type: "개인샵") ]
    }
}
