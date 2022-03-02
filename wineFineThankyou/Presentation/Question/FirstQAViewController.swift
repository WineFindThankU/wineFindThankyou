//
//  FirstQAViewController.swift
//  wineFindThankyou
//
//  Created by suding on 2022/01/17.
//

import Foundation
import UIKit

class FirstQAViewController: QAViewController {
    @IBOutlet weak var buttonCost: UIButton!
    @IBOutlet weak var buttonkind: UIButton!
    @IBOutlet weak var buttonBrand: UIButton!
    @IBOutlet weak var buttonArea: UIButton!
    @IBOutlet weak var buttonKindOfWine: UIButton!
    @IBOutlet weak var buttonOther: UIButton!
    
    @IBAction func onClickCost(_ sender: UIButton) {
        delegate?.renewButtons(sender, btns: buttons)
    }
    @IBAction func onClickKind(_ sender: UIButton) {
        delegate?.renewButtons(sender, btns: buttons)
    }
    @IBAction func onClickBrand(_ sender: UIButton) {
        delegate?.renewButtons(sender, btns: buttons)
    }
    @IBAction func onClickArea(_ sender: UIButton) {
        delegate?.renewButtons(sender, btns: buttons)
    }
    @IBAction func onClickKindOfWine(_ sender: UIButton) {
        delegate?.renewButtons(sender, btns: buttons)
    }
    @IBAction func onClickOther(_ sender: UIButton) {
        delegate?.renewButtons(sender, btns: buttons)
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let popupVC = storyBoard.instantiateViewController(withIdentifier: "QABottomSheet")
        popupVC.modalPresentationStyle = .overCurrentContext
        present(popupVC, animated: true, completion: nil)
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons = [buttonCost, buttonkind, buttonBrand, buttonArea, buttonKindOfWine, buttonOther]
    }
}
