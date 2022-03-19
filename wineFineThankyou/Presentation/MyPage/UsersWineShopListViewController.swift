//
//  UsersWineShopListViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/25.
//

import Foundation
import UIKit

class UsersWineShopListViewController: MyPageListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
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
        return cell
    }
}
