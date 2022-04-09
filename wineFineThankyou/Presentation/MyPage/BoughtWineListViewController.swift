//
//  BoughtWineListViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/23.
//

import UIKit

class BoughtWineListViewController: MyPageListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setAdditionalUI()
    }
    
    private func setAdditionalUI(){
        self.titleLabel?.font = .boldSystemFont(ofSize: 15)
        self.titleLabel?.attributedText = "내가 구매한 와인 \(boughtWines.count)".rangeSetColor(color: UIColor(rgb: 0x7B61FF), range: "\(boughtWines.count)")
    }
    
    private func deleteWine(_ key: String) {
        AFHandler.deleteWine(key) {
            //MARK: 삭제 성공/실패에 따라 다르게 적용
            guard $0 == true else { return }
            AFHandler.getMyPageData {
                guard let myPageData = $0 else { return }
                self.boughtWines = myPageData.boughtWines
                self.shops = myPageData.visitedShops
                self.setAdditionalUI()
                self.deleteProtocol?.reload(arr: self.boughtWines, type: .boughWine)
                self.deleteProtocol?.reload(arr: self.shops, type: .recentVisited)
                
                DispatchQueue.main.async {
                    if self.boughtWines.isEmpty {
                        self.dismiss(animated: true)
                    } else {
                        self.tableView.reloadData()
                    }
                }
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
        cell.shopDetail = self.shops[indexPath.row].shopDetail
        
        let boughtWine = boughtWines[indexPath.row]
        cell.wineInfo = boughtWine.wineInfo
        cell.shopDeleteBtnClosure = { [weak self] in
            self?.checkIsOk(boughtWine.wineInfo?.key ?? "")
        }
        
        cell.shopBtnClosure = {
            guard let shopKey = boughtWine.shopDetail?.key else { return }
            self.goToShop(shopKey)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    private func checkIsOk(_ key: String) {
        let alert = UIAlertController(title: "와인 샵 삭제",
                                      message: "정말 삭제하시겠습니까?",
                                      preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            self.deleteWine(key)
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}
