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
    internal var shop: Shop? {
        didSet { configure() }
    }
    
    private func configure() {
        guard let shop = shop else { return }
        shopImageView.image = nil
        
        shopTitle.text = shop.nnName
        shopTitle.textColor = UIColor(rgb: 0x424242)
        shopTitle.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        shopType.text = shop.type.str
        shopType.textColor = UIColor(rgb: 0x9e9e9e)
        shopType.font = UIFont.systemFont(ofSize: 11, weight: .regular)
    }
}
