//
//  StoreWinesViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/29.
//

import Foundation
import UIKit

class StoreWinesViewController: UIViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    var crntIndex = 0
    var wines = [WineInfo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        let backgroundView = UIView()
        backgroundView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        backgroundView.backgroundColor = Theme.black.color
        for (idx, wineInfo) in wines.enumerated() {
            let imageView = UIImageView()
            imageView.image = wineInfo.img
            imageView.contentMode = .scaleAspectFit
            let xPosition = self.view.frame.width * CGFloat(idx)
            
            imageView.frame = CGRect(x: xPosition, y: 0,
                                     width: self.view.frame.width,
                                     height: self.view.frame.height) // 즉 이미지 뷰가 화면 전체를 덮게 됨.
            
            scrollView.contentSize.width =
            self.view.frame.width * CGFloat(1 + idx)
            
            scrollView.addSubview(imageView)
        }
    }
}
