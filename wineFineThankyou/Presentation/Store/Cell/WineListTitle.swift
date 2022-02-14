//
//  WineListTitle.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/14.
//

import Foundation
import UIKit

class WineListTitle: UITableViewHeaderFooterView {
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label.text = ""
        label.clipsToBounds = true
    }
}
