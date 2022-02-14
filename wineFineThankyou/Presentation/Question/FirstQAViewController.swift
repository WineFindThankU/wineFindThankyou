//
//  FirstQAViewController.swift
//  wineFindThankyou
//
//  Created by suding on 2022/01/17.
//

import Foundation
import UIKit

protocol SelectQuestionProtocol {
    func renewButtons(_ sender: UIButton, btns: [UIButton])
}

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
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QABottomSheet") as? QABottomSheet else { return }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons = [buttonCost, buttonkind, buttonBrand, buttonArea, buttonKindOfWine, buttonOther]
    }
}
