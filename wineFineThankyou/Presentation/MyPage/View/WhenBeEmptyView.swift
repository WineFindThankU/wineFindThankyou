//
//  WhenBeEmptyView.swift
//  wineFindThankyou
//
//  Created by mun on 2022/03/29.
//

import Foundation
import UIKit

class WhenBeEmptyView: UIView {
    private weak var whenBeEmptyView: UIView!
    internal var isOnlyImg = false {
        didSet {
            isOnlyImg ? setOnlyImgView() : setAddtionalView()
        }
    }
    
    internal var superView: UIView! {
        didSet{ configure() }
    }
    
    private func configure(){
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor),
            view.leftAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leftAnchor),
            view.rightAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.rightAnchor),
            view.bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        self.whenBeEmptyView = view
    }
    
    private func setOnlyImgView() {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "MyPageEmpty")
        self.whenBeEmptyView.addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imgView.widthAnchor.constraint(equalToConstant: 52),
            imgView.heightAnchor.constraint(equalToConstant: 82),
            imgView.centerXAnchor.constraint(equalTo: self.whenBeEmptyView.centerXAnchor),
            imgView.centerYAnchor.constraint(equalTo: self.whenBeEmptyView.centerYAnchor),
        ])
    }
    
    private func setAddtionalView() {
        superView.setLineDot(color: UIColor(rgb: 0xBBADFF), radius: 12)
        
        let label = UILabel()
        let btn = UIButton()
        self.whenBeEmptyView.addSubViews(subViews: label, btn)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.whenBeEmptyView.topAnchor, constant: 83),
            label.centerXAnchor.constraint(equalTo: self.whenBeEmptyView.centerXAnchor),
            btn.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12),
            btn.centerXAnchor.constraint(equalTo: self.whenBeEmptyView.centerXAnchor),
            btn.widthAnchor.constraint(equalToConstant: 103),
            btn.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        label.numberOfLines = 0
        label.textAlignment = .center
        label.setTitle(title: "와인샵에서 구매한 와인을\n등록하면 볼 수 있어요!", txtColor: .black, font: .systemFont(ofSize: 13))
        
        btn.backgroundColor = UIColor(rgb: 0x7B61FF)
        btn.setTitle("등록하러 가기", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 13)
        btn.layer.cornerRadius = 13
        btn.addAction(UIAction {_ in
            touchPlusButton(topViewController())
        }, for: .touchUpInside)
    }
}

extension UIView {
    func setLineDot(color: UIColor, radius: CGFloat){
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = color.cgColor
        borderLayer.lineDashPattern = [7, 2]
        borderLayer.frame = self.bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath
        
        self.layer.addSublayer(borderLayer)
    }
}
