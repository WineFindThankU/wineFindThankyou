//
//  BoughtWineListViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/23.
//

import UIKit

class BoughtWineListViewController: MyPageListViewController {
    var shopsDetail = [ShopDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setShopInfo()
        setAdditionalUI()
    }
    
    private func setShopInfo() {
        shopsDetail.removeAll()
        shopsDetail.append(contentsOf: self.boughtWines.compactMap {
            $0.shopDetail
        })
    }
    
    private func setAdditionalUI(){
        self.titleLabel?.font = .boldSystemFont(ofSize: 15)
        self.titleLabel?.attributedText = "내가 구매한 와인 \(boughtWines.count)".rangeSetColor(color: UIColor(rgb: 0x7B61FF), range: "\(boughtWines.count)")
    }
    
    private func deleteWine(_ key: String) {
        AFHandler.deleteWine(key) {
            //MARK: 삭제 성공/실패에 따라 다르게 적용
            guard $0 == true else { return }
            self.boughtWines = self.boughtWines.filter { $0.wineInfo?.key != key}
            self.setShopInfo()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension BoughtWineListViewController: UITableViewDelegate, UITableViewDataSource {
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WineInfoTableViewCell.self, forCellReuseIdentifier: "WineInfoTableViewCell")
        tableView.rowHeight = 243
        tableView.estimatedRowHeight = 243
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boughtWines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WineInfoTableViewCell", for: indexPath) as? WineInfoTableViewCell else { return UITableViewCell() }
        cell.shopDetail = self.shopsDetail[indexPath.row]
        
        let boughtWine = boughtWines[indexPath.row]
        cell.wineInfo = boughtWine.wineInfo
        cell.shopDeleteBtnClosure = { [weak self] in
            self?.deleteWine(boughtWine.wineInfo?.key ?? "")
        }
        
        cell.shopBtnClosure = {
            guard let shopKey = boughtWine.shopDetail?.key else { return }
            self.goToShop(shopKey)
        }
        cell.selectionStyle = .none
        return cell
    }
}
