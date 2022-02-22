//
//  WineShopCell.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/20.
//

import Foundation
import UIKit

struct WineShopInfo {
    let image: UIImage
    let title: String
    let type: String
}

class WineShopCell: UICollectionViewCell {
    @IBOutlet private weak var shopImageView: UIImageView!
    @IBOutlet private weak var shopTitle: UILabel!
    @IBOutlet private weak var shopType: UILabel!
    
    internal var wineShopInfo: WineShopInfo? {
        didSet { configure() }
    }
    
    private func configure() {
        guard let wineShopInfo = wineShopInfo else { return }
        shopImageView.image = wineShopInfo.image
        
        shopTitle.text = wineShopInfo.title
        shopTitle.textColor = UIColor(rgb: 0x424242)
        shopTitle.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        shopType.text = wineShopInfo.type
        shopType.textColor = UIColor(rgb: 0x9e9e9e)
        shopType.font = UIFont.systemFont(ofSize: 11, weight: .regular)
    }
}
