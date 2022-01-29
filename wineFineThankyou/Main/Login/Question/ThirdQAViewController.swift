//
//  ThirdQAViewController.swift
//  wineFindThankyou
//
//  Created by suding on 2022/01/17.
//

import UIKit

class ThirdQAViewController: QAViewController {

    @IBOutlet weak var buttonMe: UIButton!
    @IBOutlet weak var buttonParty: UIButton!
    @IBOutlet weak var buttonPresent: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons = [buttonMe, buttonParty, buttonPresent]
    }
    
    @IBAction func onClickMe(_ sender: UIButton) {
        delegate?.renewButtons(sender, btns: buttons)
    }
    
    @IBAction func onClickParty(_ sender: UIButton) {
        delegate?.renewButtons(sender, btns: buttons)
    }
    
    @IBAction func onClickPresent(_ sender: UIButton) {
        delegate?.renewButtons(sender, btns: buttons)
    }
}
