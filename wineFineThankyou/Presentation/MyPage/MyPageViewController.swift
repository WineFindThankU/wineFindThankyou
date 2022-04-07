//
//  MyPageViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/31.
//

import Foundation
import UIKit

protocol DeleteProtocol: AnyObject {
    func reload(arr: [Any], type: MyPageType)
}

class MyPageViewController : UIViewController {
    private weak var topView: TopView?
    @IBOutlet private weak var statisticsView: UIView!
    @IBOutlet private weak var leftStatisticsView: UIView!
    @IBOutlet private weak var rightStatisticsView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var whenBeEmptySuperView: UIView!
    
    private var welcomeView: WelcomeView?
    var user: User!
    var boughtWines = [BoughtWine]()
    var visitedWineShops = [VisitedShop]()
    var favoritesWineShops = [VisitedShop]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTopView()
        setWelcomeView()
        setGraphView()
        setTableView()
        setAdditional()
    }
    
    @objc
    private func close() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func goToSettings() {
        guard let vc = UIStoryboard(name: StoryBoard.myPage.name, bundle: nil).instantiateViewController(withIdentifier: SettingsViewController.identifier) as? SettingsViewController
        else { return }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    private func setAdditional() {
        scrollViewHeight.constant = statisticsView.frame.height + tableView.frame.height
        
        if boughtWines.isEmpty, visitedWineShops.isEmpty {
            let whenBeEmptyView = WhenBeEmptyView()
            whenBeEmptyView.superView = whenBeEmptySuperView
            whenBeEmptySuperView.isHidden = false
            whenBeEmptyView.isOnlyImg = false
        } else {
            whenBeEmptySuperView.isHidden = true
        }
    }
}

//profileView
extension MyPageViewController: DeleteProtocol {
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
        self.view.addSubview(welcomeView)
        welcomeView.configure(superView: self.view)
        let userTasteType = Int(user.tasteType) ?? 1
        let imgName = GrapeCase.allCases.first { $0.tasteType == userTasteType }?.grapeImage ?? UIImage(named: "childGrape")
        welcomeView.userInfo = UserInfo(userImage: imgName!, userType: user.nick, wineType: calculatingMaxWineType(), userId: "guest\(user.number)")
        self.welcomeView = welcomeView
        
        func calculatingMaxWineType() -> String {
            let boughtWineTypes = boughtWines.compactMap { $0.wineInfo?.wineAtServer?.type }
            var maxType = WineType.white
            var maxVal = 0
            WineType.allCases.forEach { type in
                let crntVal = boughtWineTypes.filter { type == $0 }.count
                if maxVal < crntVal  {
                    maxType = type
                    maxVal = crntVal
                }
            }
            return maxType.str
        }
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
                wineShopCount.append(visitedWineShops.filter { $0.shopDetail?.shopType == type}.count)
            }
            return wineShopCount
        }
        
        func getBoughtWine() -> [Int] {
            return WineType.allCases.compactMap { type in
                boughtWines.compactMap { $0.wineInfo?.wineAtServer?.type }.filter { $0 == type }.count
            }
        }
    }
    
    private func goToNextStep(_ type: MypageTableViewSection) {
        let storyBoard = UIStoryboard(name: StoryBoard.myPage.name, bundle: nil)
        switch type {
        case .recentlyBoughtWine:
            guard let vc = storyBoard.instantiateViewController(withIdentifier: BoughtWineListViewController.identifier) as? BoughtWineListViewController
            else { return }
            vc.deleteProtocol = self
            vc.boughtWines = self.boughtWines
            vc.shops = visitedWineShops
            presentVc(vc)
        case .recentlyVisitedShop, .favoriteShop:
            guard let vc = storyBoard.instantiateViewController(withIdentifier: UsersWineShopListViewController.identifier) as? UsersWineShopListViewController
            else { return }
            vc.deleteProtocol = self
            vc.boughtWines = boughtWines

            if type == .recentlyVisitedShop {
                vc.myShopType = .recentVisited
                vc.shops = self.visitedWineShops
            } else if type == .favoriteShop {
                vc.myShopType = .favorites
                vc.shops = self.favoritesWineShops
            }
            
            presentVc(vc)
        }
        
        func presentVc(_ vc: UIViewController) {
            DispatchQueue.main.async {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }
    }
    
    func reload(arr: [Any], type: MyPageType) {
        switch type {
        case .boughWine:
            guard let boughtWines = arr as? [BoughtWine] else { return }
            self.boughtWines.removeAll()
            self.boughtWines.append(contentsOf: boughtWines)
        case .recentVisited:
            guard let visitedShops = arr as? [VisitedShop] else { return }
            self.visitedWineShops.removeAll()
            self.visitedWineShops.append(contentsOf: visitedShops)
        case .favorites:
            guard let favorites = arr as? [VisitedShop] else { return }
            self.favoritesWineShops.removeAll()
            self.favoritesWineShops.append(contentsOf: favorites)
        }
        
        DispatchQueue.main.async {
            self.setGraphView()
            self.setAdditional()
            self.tableView.reloadData()
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
            cell.cellInfos = self.boughtWines
        } else {
            cell.cellInfos = type == .recentlyVisitedShop ? self.visitedWineShops : self.favoritesWineShops
        }
        cell.touchRightBtn = { [weak self] in
            self?.goToNextStep(type)
        }
        cell.selectedBackgroundView?.backgroundColor = .clear
        return cell
    }
}
