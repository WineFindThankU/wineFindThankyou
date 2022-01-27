//
//  StoreInfoViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/25.
//

import Foundation
import UIKit

class StoreInfoViewController: UIViewController {
    private weak var topView: TopView?
    private weak var storeButtonView: StoreButtonsView?
    private weak var storeInfoTableView: UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        self.view.backgroundColor = Theme.white.color
        topView = setTopView(self.view, height: 44)
        storeButtonView = setStoreButtonView(superView: self.view, topView!)
        self.topView?.titleLabel?.text = "와인샵 이름"
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
            storeInfoTableView.heightAnchor.constraint(equalToConstant: 214)
        ])
        
        self.storeInfoTableView = storeInfoTableView
        makeTableView()
    }
}

extension StoreInfoViewController: UITableViewDelegate, UITableViewDataSource {
    private func makeTableView(){
        guard let storeInfoTableView = self.storeInfoTableView else { return }
        
        storeInfoTableView.delegate = self
        storeInfoTableView.dataSource = self
        storeInfoTableView.register(StoreInfoCell.self, forCellReuseIdentifier: "StoreInfoCell")
        storeInfoTableView.register(WinesInfoCell.self, forCellReuseIdentifier: "WinesInfoCell")
        storeInfoTableView.rowHeight = UITableView.automaticDimension
        storeInfoTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //section0: storeInfoBtn
        //section1: 와인리스트
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StoreInfoCell", for: indexPath) as? StoreInfoCell else { return UITableViewCell() }
            guard let storeInfo = StoreInfo(rawValue: indexPath.row) else { return cell }
            cell.imgView?.image = UIImage(named: storeInfo.imgName)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WinesInfoCell", for: indexPath) as? WinesInfoCell else { return UITableViewCell() }
            cell.wineInfos.append(WineInfo(wineImg: UIImage(named: "clock")!, wineName: "clock"))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            switch StoreInfo(rawValue: indexPath.row) {
            default: return 45
            }
        } else {
            return 120
        }
    }
}

