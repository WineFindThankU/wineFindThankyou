//
//  colTestCell.swift
//  NewToy
//
//  Created by mun on 2022/01/28.
//

import Foundation
import UIKit
class WineInfoCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var back: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    var radius: CGFloat = 0.0 {
        willSet(new) {
            back.layer.cornerRadius = radius
            back.layer.masksToBounds = radius > 0.0 ? true : false
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        name.isHidden = false
        name.textColor = UIColor.purple
    }
}
