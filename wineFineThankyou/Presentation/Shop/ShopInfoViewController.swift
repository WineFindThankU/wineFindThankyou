//
//  ShopInfoViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/25.
//

import Foundation
import UIKit

class ShopInfoViewController: ShopContainedButtonViewController, SelectedWineCellProtocol {
    enum TableSection: Int, CaseIterable {
        case ShopInfo = 0
        case WineList = 1
    }
    private unowned var topView: TopView?
    private unowned var shopInfoTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setTopView()
        setContentsView()
    }
    
    func setTopView() {
        let topView = getGlobalTopView(self.view, height: 44)
        topView.titleLabel?.text = shop.nnName
        topView.leftButton?.setBackgroundImage(UIImage(named: "backArrow"), for: .normal)
        topView.leftButton?.addTarget(self, action: #selector(close), for: .touchUpInside)
        self.topView = topView
    }
    
    private func setContentsView() {
        guard let topView = topView else { return }
        
        self.view.backgroundColor = Theme.white.color
        shopBtnsView = setShopButtonView(superView: self.view, topView)
        let shopInfoTableView = UITableView()
        self.view.addSubview(shopInfoTableView)
        shopInfoTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shopInfoTableView.topAnchor.constraint(equalTo: shopBtnsView.bottomAnchor),
            shopInfoTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            shopInfoTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            shopInfoTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        self.shopInfoTableView = shopInfoTableView
        makeTableView()
    }
    
    func selectedCell(_ row: Int) {
        guard let vc = UIStoryboard(name: StoryBoard.shop.name, bundle: nil).instantiateViewController(withIdentifier: ShopWinesViewController.identifier) as? ShopWinesViewController else {
             return
        }
        vc.crntIndex = row
        vc.wineInfos = shop.userWines
        vc.modalPresentationStyle = .overFullScreen
        
        self.present(vc, animated: true)
    }
}

extension ShopInfoViewController: UITableViewDelegate, UITableViewDataSource {
    private func makeTableView(){
        guard let shopInfoTableView = self.shopInfoTableView else { return }
        
        shopInfoTableView.delegate = self
        shopInfoTableView.dataSource = self
        shopInfoTableView.register(ShopInfoCell.self, forCellReuseIdentifier: "ShopInfoCell")
        shopInfoTableView.register(UINib(nibName: "AllOfWineInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "AllOfWineInfoTableViewCell")
        shopInfoTableView.register(UINib(nibName: "WineListTitle", bundle: nil), forHeaderFooterViewReuseIdentifier: "WineListTitle")
        shopInfoTableView.rowHeight = UITableView.automaticDimension
        shopInfoTableView.estimatedRowHeight = UITableView.automaticDimension
        shopInfoTableView.isUserInteractionEnabled = false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if TableSection(rawValue: section) == .ShopInfo { return 4 }
        else { return 1 }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard TableSection(rawValue: section) == .WineList else { return 0 }
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard TableSection(rawValue: section) == .WineList else { return nil }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "WineListTitle") as? WineListTitle
        header?.label.text = "와인리스트 \(shop.userWines.count)"
        header?.backgroundColor = .red
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if TableSection(rawValue: indexPath.section) == .ShopInfo {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShopInfoCell", for: indexPath) as? ShopInfoCell else { return UITableViewCell() }
            return setSection0OfCell(cell, indexPath.row)
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllOfWineInfoTableViewCell", for: indexPath) as? AllOfWineInfoTableViewCell
            else { return UITableViewCell() }
            cell.delegate = self
            cell.winesAtServer = self.shop.userWines.compactMap { $0.wineAtServer }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if TableSection(rawValue: indexPath.section) == .ShopInfo {
            switch ShopInfo(rawValue: indexPath.row) {
            default: return 45
            }
        } else {
            return UIScreen.main.bounds.height - (45 * 4)
        }
    }
    
    private func setSection0OfCell(_ cell: ShopInfoCell, _ row: Int) -> ShopInfoCell{
        guard let shopInfo = ShopInfo(rawValue: row)
        else { return cell }
        
        cell.imgView?.image = UIImage(named: shopInfo.imgName)
        switch row {
        case 0:
            cell.info?.text = shop.nnTellNumber
        case 1:
            cell.info?.text = shop.nnAddress
        case 2:
            cell.info?.text = ""
        case 3:
            cell.info?.text = shop.nnHomepage
        default:
            break
        }
        return cell
    }
}
