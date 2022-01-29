//
//  WinesInfoStackView.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/29.
//

import Foundation
import UIKit

class WinesInfoStackView: UIView{
    @IBOutlet var contentsView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var subView0: WineInfoView!
    @IBOutlet weak var subView1: WineInfoView!
    @IBOutlet weak var subView2: WineInfoView!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    private func configure() {
        Bundle.main.loadNibNamed("WinesInfoStackView", owner: self, options: nil)
        addSubview(contentsView)
    }
    
    internal func setArrangeView(idx: Int, _ img: UIImage, _ name: String) {
        switch idx {
        case 0:
            subView0.imgView.image = img
            subView0.label.text = name
        case 1:
            subView1.imgView.image = img
            subView1.label.text = name
        case 2:
            subView2.imgView.image = img
            subView2.label.text = name
        default: ()
        }
        stackViewHeight.constant = 20
    }
}
