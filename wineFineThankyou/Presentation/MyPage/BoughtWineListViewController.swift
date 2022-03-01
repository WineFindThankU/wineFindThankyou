//
//  BoughtWineListViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/23.
//

import UIKit

class BoughtWineListViewController: MyPageListViewController {
    //MARK: TEST
    var wineInfos = [WineInfo]()
    var wineStoreInfos = [WineStoreInfo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
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
        cell.wineStoreInfo = wineStoreInfos.first{ $0.key == wineInfo.storeFk }
        cell.wineInfo = wineInfo
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
