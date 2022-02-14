//
//  QABottomSheet.swift
//  wineFindThankyou
//
//  Created by suding on 2022/02/14.
//

import Foundation
import UIKit

class QABottomSheet: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var checkButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private let setUI() {
        checkButton.isEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let image: UIImage = UIImage(named:"textFieldButton")!
        
        checkButton.isEnabled = true
        checkButton.setImage(image, for: UIControlState.normal)
    }
    @IBAction func onClickButton(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
}
