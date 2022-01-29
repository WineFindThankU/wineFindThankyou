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
    var wines = [WineInfo]()
    var pixel: CGFloat = 0.0
    var delegate: SelectedWineCellProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        print("AllOfWineInfoTableViewCell: \(collectionView)")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8.0
        layout.minimumLineSpacing = 8.0
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: "WineInfoCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "WineInfoCollectionViewCell")
        let sidePadding: CGFloat = 36.0
        pixel = floor(CGFloat(Int((UIScreen.main.bounds.size.width-8.0*3.0-sidePadding)/4.0)))
    }
}
extension AllOfWineInfoTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(wines.count)
        return wines.count
    }
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: pixel, height: pixel)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WineInfoCollectionViewCell", for: indexPath) as? WineInfoCollectionViewCell {
            cell.name.text = wines[indexPath.row].name
            print("name: \( wines[indexPath.row].name)")
            cell.img = UIImageView(image: wines[indexPath.row].img)
            cell.radius = 3.0
            return cell
        }
        print("cell")
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectedCell(indexPath.row)
    }
}
