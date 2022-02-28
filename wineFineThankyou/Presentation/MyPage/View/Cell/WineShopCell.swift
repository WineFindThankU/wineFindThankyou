//
//  WineShopCell.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/20.
//

import Foundation
import UIKit

class WineShopCell: UICollectionViewCell {
    @IBOutlet private weak var shopImageView: UIImageView!
    @IBOutlet private weak var shopTitle: UILabel!
    @IBOutlet private weak var shopType: UILabel!
    
    internal var wineStoreInfo: WineStoreInfo? {
        didSet { configure() }
    }
    
    private func configure() {
        guard let wineStoreInfo = wineStoreInfo else { return }
        shopImageView.image = nil
        
        shopTitle.text = wineStoreInfo.storeName
        shopTitle.textColor = UIColor(rgb: 0x424242)
        shopTitle.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        shopType.text = wineStoreInfo.classification.str
        shopType.textColor = UIColor(rgb: 0x9e9e9e)
        shopType.font = UIFont.systemFont(ofSize: 11, weight: .regular)
    }
}
