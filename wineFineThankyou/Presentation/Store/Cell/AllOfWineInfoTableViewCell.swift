//
//  testCell.swift
//  NewToy
//
//  Created by mun on 2022/01/28.
//

import Foundation
import UIKit

protocol SelectedWineCellProtocol {
    func selectedCell(_ row: Int)
}
class AllOfWineInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    internal var wineInfos : [WineInfo] = []
    var delegate: SelectedWineCellProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = Theme.gray.color
        collectionView.register(UINib(nibName: "WineInfoCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "WineInfoCollectionViewCell")
    }
}
extension AllOfWineInfoTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wineInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WineInfoCollectionViewCell", for: indexPath) as? WineInfoCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.wineInfo = wineInfos[indexPath.row]
        cell.setBackgroundColor()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectedCell(indexPath.row)
    }
}
