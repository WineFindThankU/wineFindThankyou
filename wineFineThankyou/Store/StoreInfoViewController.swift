//
//  StoreInfoViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/25.
//

import Foundation
import UIKit

class StoreInfoViewController: UIViewController, SelectedWineCellProtocol {
    private weak var topView: TopView?
    private weak var storeButtonView: StoreButtonsView?
    private weak var storeInfoTableView: UITableView?
    var wineStoreInfo: WineStoreInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        self.view.backgroundColor = Theme.white.color
        topView = setTopView(self.view, height: 44)
        storeButtonView = setStoreButtonView(superView: self.view, topView!)
        self.topView?.titleLabel?.text = wineStoreInfo?.storeName
        self.topView?.leftButton?.setBackgroundImage(UIImage(named: "backArrow"), for: .normal)
        
        guard let storeButtonView = storeButtonView else {
            return
        }

        let storeInfoTableView = UITableView()
        self.view.addSubview(storeInfoTableView)
        storeInfoTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            storeInfoTableView.topAnchor.constraint(equalTo: storeButtonView.bottomAnchor),
            storeInfoTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            storeInfoTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            storeInfoTableView.heightAnchor.constraint(equalToConstant: 700)
        ])
        
        self.storeInfoTableView = storeInfoTableView
        makeTableView()
    }
    
    func selectedCell(_ row: Int) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StoreWinesViewController") as? StoreWinesViewController else {
             return
        }
        vc.crntIndex = row
        vc.wines = self.wineStoreInfo?.wines ?? []
        self.present(vc, animated: true)
    }
}

extension StoreInfoViewController: UITableViewDelegate, UITableViewDataSource {
    private func makeTableView(){
        guard let storeInfoTableView = self.storeInfoTableView else { return }
        
        storeInfoTableView.delegate = self
        storeInfoTableView.dataSource = self
        storeInfoTableView.register(StoreInfoCell.self, forCellReuseIdentifier: "StoreInfoCell")
        storeInfoTableView.register(UINib(nibName: "AllOfWineInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "AllOfWineInfoTableViewCell")
        storeInfoTableView.rowHeight = UITableView.automaticDimension
        storeInfoTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //section0: storeInfoBtn
        //section1: 와인리스트
        if section == 0 {
            return 4
        } else { return 1}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StoreInfoCell", for: indexPath) as? StoreInfoCell else { return UITableViewCell() }
            
            return setSection0OfCell(cell, indexPath.row)
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllOfWineInfoTableViewCell", for: indexPath) as? AllOfWineInfoTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.wines = wineStoreInfo?.wines ?? []
            return cell
        }
    }
    
    func setSection0OfCell(_ cell: StoreInfoCell, _ row: Int) -> StoreInfoCell{
        guard let storeInfo = StoreInfo(rawValue: row) else { return cell }
        cell.imgView?.image = UIImage(named: storeInfo.imgName)
        switch row {
        case 0:
            cell.info?.text = wineStoreInfo?.callNumber
        case 1:
            cell.info?.text = wineStoreInfo?.location
        case 2:
            cell.info?.text = wineStoreInfo?.openingHours
        case 3:
            cell.info?.text = wineStoreInfo?.homepage
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            switch StoreInfo(rawValue: indexPath.row) {
            default: return 45
            }
        } else {
            return 300
        }
    }
}

