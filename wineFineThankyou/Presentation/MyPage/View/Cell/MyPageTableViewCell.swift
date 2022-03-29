//
//  MyPageTableViewCell.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/20.
//

import Foundation
import UIKit

enum MypageTableViewSection: Int, CaseIterable {
    case recentlyBoughtWine = 0
    case recentlyVisitedShop = 1
    case favoriteShop = 2
    var title: String {
        switch self {
        case .recentlyBoughtWine:
            return "최근 구매한 와인"
        case .recentlyVisitedShop:
            return "최근 다녀온 와인샵"
        case .favoriteShop:
            return "즐겨찾는 와인샵"
        }
    }
}

class MyPageTableViewCell: UITableViewCell{
    @IBOutlet private weak var sectionTitle: UILabel!
    @IBOutlet private weak var rightBtn: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var emptyView: UIView!
    internal var touchRightBtn: (() -> Void)?
    internal var sectionType: MypageTableViewSection? {
        didSet{ setCell() }
    }
    
    internal var cellInfos: [Any] = [] {
        didSet { updateUI() }
    }
    
    private func setCell() {
        guard let buttonType = self.sectionType else {
            return
        }
        sectionTitle.text = buttonType.title
        rightBtn.addTarget(self, action: #selector(goToNextStep), for: .touchUpInside)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "WineInfoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WineInfoCollectionViewCell")
        collectionView.register(UINib(nibName: "WineShopCell", bundle: nil), forCellWithReuseIdentifier: "WineShopCell")
        
        let whenBeEmptyView = WhenBeEmptyView()
        emptyView.addSubview(whenBeEmptyView)
        whenBeEmptyView.superView = emptyView
        whenBeEmptyView.isOnlyImg = true
    }
    
    private func updateUI() {
        DispatchQueue.main.async { [self] in
            if cellInfos.isEmpty {
                emptyView.isHidden = false
                rightBtn.isHidden = true
            } else {
                emptyView.isHidden = true
                rightBtn.isHidden = false
                collectionView.reloadData()
            }
        }
    }
        
    @objc
    private func goToNextStep() {
        touchRightBtn?()
    }
}

extension MyPageTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let buttonType = sectionType else { return UICollectionViewCell() }
        
        switch buttonType {
        case .recentlyBoughtWine:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WineInfoCollectionViewCell", for: indexPath) as? WineInfoCollectionViewCell,
                  let boughtWine = self.cellInfos[indexPath.row] as? BoughtWine
            else { return UICollectionViewCell() }
        
            cell.tupleVal = (boughtWine.name, boughtWine.wineInfo?.wineAtServer?.imgUrlStr)
            cell.backgroundView?.backgroundColor = .clear
            return cell
        case .recentlyVisitedShop, .favoriteShop:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WineShopCell", for: indexPath) as? WineShopCell
            else { return UICollectionViewCell() }
            
            cell.shop = self.cellInfos[indexPath.row] as? VisitedShop
            cell.backgroundView?.backgroundColor = .clear
            return cell
        }
    }
}
