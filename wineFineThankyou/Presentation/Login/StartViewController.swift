//
//  StartViewController.swift
//  wineFindThankyou
//
//  Created by betty on 2022/02/04.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onClickStart(_ sender: Any) {
        let view = WalkthroughMainViewController()
        view.modalPresentationStyle = .overFullScreen
        DispatchQueue.main.async {
            self.present(view, animated: true)
        }
    }
    

}
