//
//  WinesInfoCell.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/27.
//

import Foundation
import UIKit

struct WineInfo {
    let wineImg : UIImage
    let wineName : String
}

class WineInfoCell: UICollectionViewCell{
    var wineInfo: WineInfo? {
        didSet{
            self.imageView.image = wineInfo?.wineImg
            self.wineLabel.text = wineInfo?.wineName
        }
    }
    let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    let wineLabel: UILabel = {
        let wineLabel = UILabel()
        return wineLabel
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure(){
        backgroundColor = .systemGroupedBackground
        addSubview(imageView)
        addSubview(wineLabel)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        wineLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 46.93),
            imageView.heightAnchor.constraint(equalToConstant: 105)
        ])
    }
}

class WinesInfoCell: UITableViewCell{
    var winesCollectionView: UICollectionView?
    var wineInfos = [WineInfo]()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    private func configure() {
        //Test
        let flowLayout = UICollectionViewFlowLayout()
        let winesCollectionView = UICollectionView(frame: .init(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: flowLayout)
        self.contentView.addSubview(winesCollectionView)
        winesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            winesCollectionView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            winesCollectionView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            winesCollectionView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            winesCollectionView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        winesCollectionView.delegate = self
        winesCollectionView.dataSource = self
        winesCollectionView.register(WineInfoCell.self, forCellWithReuseIdentifier: "WineInfoCell")
        winesCollectionView.backgroundColor = .red
        self.winesCollectionView = winesCollectionView
    }
}

extension WinesInfoCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wineInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let wineInfoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WineInfoCell", for: indexPath) as! WineInfoCell
        wineInfoCell.wineInfo = wineInfos[indexPath.row]
        return wineInfoCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 129)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
