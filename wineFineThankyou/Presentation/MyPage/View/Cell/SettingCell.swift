//
//  SettingCell.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/06.
//

import Foundation
import UIKit

class SettingCell: UITableViewCell{
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var onOffSwitch: UISwitch!

    @IBAction func onOffAction(_ sender: UISwitch) {
        UserData.isConvenienceOn = sender.isOn
    }
}
