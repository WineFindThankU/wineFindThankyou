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
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    override func touchPlusButton() {
        
    }
}

extension BoughtWineListViewController: UITableViewDelegate, UITableViewDataSource {
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WineInfoTableViewCell.self, forCellReuseIdentifier: "WineInfoTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wineInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WineInfoTableViewCell", for: indexPath) as? WineInfoTableViewCell else { return UITableViewCell() }
        cell.info = wineInfos[indexPath.row]
        return cell
    }
}
