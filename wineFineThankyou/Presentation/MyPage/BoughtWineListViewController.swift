//
//  BoughtWineListViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/23.
//

import UIKit

class BoughtWineListViewController: MyPageListViewController {
    //MARK: TEST
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    private func deleteWine(_ key: String) {
        AFHandler.deleteWine(key) {
            //MARK: 삭제 성공/실패에 따라 다르게 적용
            
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
        return wineInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WineInfoTableViewCell", for: indexPath) as? WineInfoTableViewCell else { return UITableViewCell() }
        
        let wineInfo = wineInfos[indexPath.row]
        cell.shop = shops.first{ $0.key == wineInfo.shopFk }
        cell.wineInfo = wineInfo
        cell.shopDeleteBtnClosure = { [weak self] in
            //MARK: wineKEY 전달
            self?.deleteWine("WINEINFO KEY STRING")
        }
        cell.shopBtnClosure = { [weak self] in
            self?.goToShop(wineInfo.shopFk)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
