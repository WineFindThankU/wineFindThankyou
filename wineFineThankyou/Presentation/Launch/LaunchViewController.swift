//
//  LaunchViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/29.
//

import Foundation
import UIKit
class LaunchViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.present(UIStoryboard(name: StoryBoard.main.name, bundle: nil).instantiateViewController(withIdentifier: StartViewController.identifier), animated: true)
        }
    }
}
