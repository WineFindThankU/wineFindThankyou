//
//  WineDetailsView.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/15.
//

import Foundation
import UIKit

class WineDetailsView: UIView {
    @IBOutlet private weak var korName: UILabel! {
        didSet {
            korName.textColor = Theme.white.color
            korName.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        }
    }
    @IBOutlet private weak var engName: UILabel! {
        didSet {
            engName.textColor = Theme.gray.color
            engName.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        }
    }
    @IBOutlet private weak var line: UIView!
    
    @IBOutlet weak var cepage: UILabel!
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var vintage: UILabel!
    @IBOutlet weak var alchol: UILabel!
    internal var wineDetail: WineInfo! {
        didSet {
//            korName.text = wineDetail.korName
//            engName.text = wineDetail.engName
        }
    }
}
