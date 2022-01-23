//
//  MainViewController.swift
//  wineFindThankyou
//
//  Created by suding on 2022/01/23.
//

import UIKit
import NMapsMap
class MainViewController: UIViewController {
    
    override func viewDidLoad() {
            super.viewDidLoad()
            let naverMapView = NMFNaverMapView(frame: view.frame)
            view.addSubview(naverMapView)
    }

}
