//
//  ThirdQAViewController.swift
//  wineFindThankyou
//
//  Created by suding on 2022/01/17.
//

import UIKit

class ThirdQAViewController: UIViewController {

    @IBOutlet weak var buttonMe: UIButton!
    
    @IBOutlet weak var buttonParty: UIButton!
    
    @IBOutlet weak var buttonPresent: UIButton!
    
    
    let selectImage : UIImage = UIImage(named:"selectedStandard")!
    let noselectImage: UIImage  = UIImage(named:"Quesbutton")!
    
    var buttonValue = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func onClickMe(_ sender: Any) {
        buttonValue = !buttonValue

        if buttonValue == true {
            buttonMe.setBackgroundImage(selectImage, for: .normal)
            buttonMe.setTitleColor(UIColor.white, for: .normal)
        } else {
            buttonMe.setBackgroundImage(noselectImage, for: .normal)
            buttonMe.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    @IBAction func onClickParty(_ sender: Any) {
        buttonValue = !buttonValue

        if buttonValue == true {
            buttonParty.setBackgroundImage(selectImage, for: .normal)
            buttonParty.setTitleColor(UIColor.white, for: .normal)
        } else {
            buttonParty.setBackgroundImage(noselectImage, for: .normal)
            buttonParty.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    @IBAction func onClickPresent(_ sender: Any) {
        buttonValue = !buttonValue

        if buttonValue == true {
            buttonPresent.setBackgroundImage(selectImage, for: .normal)
            buttonPresent.setTitleColor(UIColor.white, for: .normal)
        } else {
            buttonPresent.setBackgroundImage(noselectImage, for: .normal)
            buttonPresent.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
}
