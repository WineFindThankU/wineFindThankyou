//
//  WineInfoView.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/28.
//

import Foundation
import UIKit
class WineInfoView: UIView{
    @IBOutlet var contentsView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var moreBtn: UIButton!
    var moreBtnClosure: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    private func configure() {
        Bundle.main.loadNibNamed("WineInfoView", owner: self, options: nil)
        addSubview(contentsView)
    }
    func setView(_ img: UIImage,
                 _ name: String){
        self.imgView.image = img
        self.label.text = name
    }
    func lastView(){
        moreView.isHidden = true
        moreBtn.addTarget(self, action: #selector(goToMore), for: .touchUpInside)
    }
    
    @objc
    func goToMore(){
        moreBtnClosure?()
    }
}
