//
//  StoreInfoViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/25.
//

import Foundation
import UIKit

class StoreInfoViewController: ContainStoreButtonViewController, SelectedWineCellProtocol {
    enum TableSection: Int, CaseIterable {
        case StoreInfo = 0
        case WineList = 1
    }
    private unowned var topView: TopView?
    private unowned var storeInfoTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setTopView()
        setContentsView()
    }
    
    func setTopView() {
        let topView = getGlobalTopView(self.view, height: 44)
        topView.titleLabel?.text = shopInfo.nnName
        topView.leftButton?.setBackgroundImage(UIImage(named: "backArrow"), for: .normal)
        topView.leftButton?.addTarget(self, action: #selector(close), for: .touchUpInside)
        self.topView = topView
    }
    
    private func setContentsView() {
        guard let topView = topView else { return }
        
        self.view.backgroundColor = Theme.white.color
        let storeBtnsView = setStoreButtonView(superView: self.view, topView)
        let storeInfoTableView = UITableView()
        self.view.addSubview(storeInfoTableView)
        storeInfoTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            storeInfoTableView.topAnchor.constraint(equalTo: storeBtnsView.bottomAnchor),
            storeInfoTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            storeInfoTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            storeInfoTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        storeButtonsView = storeBtnsView
        self.storeInfoTableView = storeInfoTableView
        makeTableView()
    }
    
    func selectedCell(_ row: Int) {
        guard let vc = UIStoryboard(name: StoryBoard.store.name, bundle: nil).instantiateViewController(withIdentifier: StoreWinesViewController.identifier) as? StoreWinesViewController else {
             return
        }
        vc.crntIndex = row
        vc.wineInfos = wineInfos
        vc.modalPresentationStyle = .overFullScreen
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
        storeInfoTableView.register(UINib(nibName: "WineListTitle", bundle: nil), forHeaderFooterViewReuseIdentifier: "WineListTitle")
        storeInfoTableView.rowHeight = UITableView.automaticDimension
        storeInfoTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if TableSection(rawValue: section) == .StoreInfo { return 4 }
        else { return 1 }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard TableSection(rawValue: section) == .WineList else { return 0 }
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard TableSection(rawValue: section) == .WineList else { return nil }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "WineListTitle") as? WineListTitle
        header?.label.text = "와인리스트 \(wineInfos.count)"
        header?.backgroundColor = .red
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if TableSection(rawValue: indexPath.section) == .StoreInfo {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StoreInfoCell", for: indexPath) as? StoreInfoCell else { return UITableViewCell() }
            return setSection0OfCell(cell, indexPath.row)
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllOfWineInfoTableViewCell", for: indexPath) as? AllOfWineInfoTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.wineInfos = wineInfos
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if TableSection(rawValue: indexPath.section) == .StoreInfo {
            switch StoreInfo(rawValue: indexPath.row) {
            default: return 45
            }
        } else {
            return UIScreen.main.bounds.height - (45 * 4)
        }
    }
    
    private func setSection0OfCell(_ cell: StoreInfoCell, _ row: Int) -> StoreInfoCell{
        guard let storeInfo = StoreInfo(rawValue: row) else { return cell }
        cell.imgView?.image = UIImage(named: storeInfo.imgName)
        switch row {
        case 0:
            cell.info?.text = shopInfo.nnTellNumber
        case 1:
            cell.info?.text = shopInfo.nnAddress
        case 2:
            cell.info?.text = ""
        case 3:
            cell.info?.text = shopInfo.nnHomepage
        default:
            break
        }
        return cell
    }
}
