//
//  UsersWineShopListViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/25.
//

import Foundation
import UIKit

enum MyPageType {
    case boughWine
    case recentVisited
    case favorites
}

class UsersWineShopListViewController: MyPageListViewController {
    internal var myShopType: MyPageType = .favorites
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setAdditionalUI()
    }
    
    private func setAdditionalUI(){
        self.titleLabel?.font = .boldSystemFont(ofSize: 15)
        
        if myShopType == .favorites {
            self.titleLabel?.attributedText = "즐겨찾는 와인샵 \(shops.count)".rangeSetColor(color: UIColor(rgb: 0x7B61FF), range: "\(shops.count)")
        } else {
            self.titleLabel?.attributedText = "다녀온 와인샵 \(shops.count)".rangeSetColor(color: UIColor(rgb: 0x7B61FF), range: "\(shops.count)")
        }
    }
    
    private func deleteShop(_ wineKeys: [String]) {
        let group = DispatchGroup()
        wineKeys.forEach { key in
            group.enter()
            AFHandler.queue.async {
                AFHandler.deleteWine(key) {
                    guard $0 == true else { return }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: AFHandler.queue) {
            AFHandler.getMyPageData {
                guard let myPageData = $0 else { return }
                self.boughtWines = myPageData.boughtWines
                self.shops = myPageData.visitedShops
                self.deleteProtocol?.reload(arr: self.boughtWines, type: .boughWine)
                self.deleteProtocol?.reload(arr: self.shops, type: .recentVisited)
                
                self.setAdditionalUI()
                DispatchQueue.main.async {
                    if self.shops.isEmpty {
                        self.dismiss(animated: true)
                    } else {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

extension UsersWineShopListViewController: UITableViewDelegate, UITableViewDataSource {
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserWineShopListTableViewCell.self, forCellReuseIdentifier: "UserWineShopListTableViewCell")
        tableView.rowHeight = 112
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserWineShopListTableViewCell", for: indexPath) as? UserWineShopListTableViewCell else { return UITableViewCell() }
        let shop = shops[indexPath.row]
        cell.wineCount = shop.wineCount
        cell.shop = shop
        cell.selectionStyle = .none
        cell.deleteClosure = {
            self.checkIsOk(shop)
        }
        cell.isVisitedType = self.myShopType == .recentVisited
        return cell
    }
    
    private func checkIsOk(_ shop: VisitedShop) {
        let alert = UIAlertController(title: "와인 샵 삭제", message: "정말 삭제하시겠습니까?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: "확인", style: .default, handler: { _ in
            let filtered = self.boughtWines.filter { $0.shopDetail?.key == shop.shopDetail?.key }.compactMap { $0.wineInfo?.key }
            self.deleteShop(filtered)
        })
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}
