//
//  SecondQAViewController.swift
//  wineFindThankyou
//
//  Created by suding on 2022/01/17.
//

import UIKit

class SecondQAViewController: QAViewController {
    @IBOutlet weak var button2m: UIButton!
    @IBOutlet weak var button3m: UIButton!
    @IBOutlet weak var button5m: UIButton!
    @IBOutlet weak var button8m: UIButton!
    @IBOutlet weak var buttonDontCare: UIButton!
    
    @IBAction func onClick2m(_ sender: UIButton) {
        delegate?.renewButtons(sender, btns: buttons)
    }
    
    @IBAction func onClick3m(_ sender: UIButton) {
        delegate?.renewButtons(sender, btns: buttons)
    }
    
    @IBAction func onClick5m(_ sender: UIButton) {
        delegate?.renewButtons(sender, btns: buttons)
    }
    
    @IBAction func onClick8m(_ sender: UIButton) {
        delegate?.renewButtons(sender, btns: buttons)
    }
    
    @IBAction func onClickdontcare(_ sender: UIButton) {
        delegate?.renewButtons(sender, btns: buttons)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons = [button2m, button3m, button5m, button8m, buttonDontCare]
    }
}
