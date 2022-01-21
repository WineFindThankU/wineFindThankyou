//
//  FirstQAViewController.swift
//  wineFindThankyou
//
//  Created by suding on 2022/01/17.
//

import Foundation
import UIKit

class FirstQAViewController: UIViewController {
    @IBOutlet weak var buttonCost: UIButton!
    @IBOutlet weak var buttonkind: UIButton!
    @IBOutlet weak var buttonBrand: UIButton!
    @IBOutlet weak var buttonArea: UIButton!
    @IBOutlet weak var buttonKindOfWine: UIButton!
    @IBOutlet weak var buttonOther: UIButton!
    
    
   
    
    
    let selectImage : UIImage = UIImage(named:"selectedStandard")!
    let noselectImage: UIImage  = UIImage(named:"Quesbutton")!
    
    var buttonValue = false

    
    @IBAction func onClickCost(_ sender: Any) {
        
        buttonValue = !buttonValue

        if buttonValue == true {
            buttonCost.setBackgroundImage(selectImage, for: .normal)
            buttonCost.setTitleColor(UIColor.white, for: .normal)
            
        } else {
            buttonCost.setBackgroundImage(noselectImage, for: .normal)
            buttonCost.setTitleColor(UIColor.black, for: .normal)
        }
       
    }
    
    @IBAction func onClickKind(_ sender: Any) {
        
        buttonValue = !buttonValue
        
        if buttonValue == true {
            buttonkind.setBackgroundImage(selectImage, for: .normal)
            buttonkind.setTitleColor(UIColor.white, for: .normal)
        } else {
            buttonkind.setBackgroundImage(noselectImage, for: .normal)
            buttonkind.setTitleColor(UIColor.black, for: .normal)
        }
        
    }
    
    
    @IBAction func onClickBrand(_ sender: Any) {
        buttonValue = !buttonValue

        if buttonValue == true {
            buttonBrand.setBackgroundImage(selectImage, for: .normal)
            buttonBrand.setTitleColor(UIColor.white, for: .normal)
        } else {
            buttonBrand.setBackgroundImage(noselectImage, for: .normal)
            buttonBrand.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    @IBAction func onClickArea(_ sender: Any) {
        buttonValue = !buttonValue

        if buttonValue == true {
            buttonArea.setBackgroundImage(selectImage, for: .normal)
            buttonArea.setTitleColor(UIColor.white, for: .normal)
        } else {
            buttonArea.setBackgroundImage(noselectImage, for: .normal)
            buttonArea.setTitleColor(UIColor.black, for: .normal)
        }
    }
    @IBAction func onClickKindOfWine(_ sender: Any) {
        buttonValue = !buttonValue

        if buttonValue == true {
            buttonKindOfWine.setBackgroundImage(selectImage, for: .normal)
            buttonKindOfWine.setTitleColor(UIColor.white, for: .normal)
        } else {
            buttonKindOfWine.setBackgroundImage(noselectImage, for: .normal)
            buttonKindOfWine.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    
    @IBAction func onClickOther(_ sender: Any) {
        buttonValue = !buttonValue

        if buttonValue == true {
            buttonOther.setBackgroundImage(selectImage, for: .normal)
            buttonOther.setTitleColor(UIColor.white, for: .normal)
        } else {
            buttonOther.setBackgroundImage(noselectImage, for: .normal)
            buttonOther.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


    }
    
    

}
