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
    @IBOutlet weak var collectionView: UICollectionView!
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
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WineInfoCollectionViewCell", for: indexPath) as? WineInfoCollectionViewCell
            else { return UICollectionViewCell() }
            
            cell.wineInfo = self.cellInfos[indexPath.row] as? WineInfo
            return cell
        case .recentlyVisitedShop, .favoriteShop:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WineShopCell", for: indexPath) as? WineShopCell
            else { return UICollectionViewCell() }
            
            cell.wineStoreInfo = self.cellInfos[indexPath.row] as? WineStoreInfo
            return cell
        }
    }
}
