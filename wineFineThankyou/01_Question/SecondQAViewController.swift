//
//  SecondQAViewController.swift
//  wineFindThankyou
//
//  Created by suding on 2022/01/17.
//

import UIKit

class SecondQAViewController: UIViewController {
    
    @IBOutlet weak var button2m: UIButton!
    
    @IBOutlet weak var button3m: UIButton!
    
    @IBOutlet weak var button5m: UIButton!
    
    @IBOutlet weak var button8m: UIButton!
    
    @IBOutlet weak var buttonDontCare: UIButton!
    
    var buttonValue = false
 
    let selectImage : UIImage = UIImage(named:"selectedStandard")!
    let noselectImage: UIImage  = UIImage(named:"Quesbutton")!
    
    @IBAction func onClick2m(_ sender: Any) {
        
        buttonValue = !buttonValue

        if buttonValue == true {
            button2m.setBackgroundImage(selectImage, for: .normal)
            button2m.setTitleColor(UIColor.white, for: .normal)
        } else {
            button2m.setBackgroundImage(noselectImage, for: .normal)
            button2m.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    @IBAction func onClick3m(_ sender: Any) {
        buttonValue = !buttonValue

        if buttonValue == true {
            button3m.setBackgroundImage(selectImage, for: .normal)
            button3m.setTitleColor(UIColor.white, for: .normal)
        } else {
            button3m.setBackgroundImage(noselectImage, for: .normal)
            button3m.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    @IBAction func onClick5m(_ sender: Any) {
        buttonValue = !buttonValue

        if buttonValue == true {
            button5m.setBackgroundImage(selectImage, for: .normal)
            button5m.setTitleColor(UIColor.white, for: .normal)
        } else {
            button5m.setBackgroundImage(noselectImage, for: .normal)
            button5m.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    @IBAction func onClick8m(_ sender: Any) {
        buttonValue = !buttonValue

        if buttonValue == true {
            button8m.setBackgroundImage(selectImage, for: .normal)
            button8m.setTitleColor(UIColor.white, for: .normal)
        } else {
            button8m.setBackgroundImage(noselectImage, for: .normal)
            button8m.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    @IBAction func onClickdontcare(_ sender: Any) {
        buttonValue = !buttonValue

        if buttonValue == true {
            buttonDontCare.setBackgroundImage(selectImage, for: .normal)
            buttonDontCare.setTitleColor(UIColor.white, for: .normal)
        } else {
            buttonDontCare.setBackgroundImage(noselectImage, for: .normal)
            buttonDontCare.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    


}
