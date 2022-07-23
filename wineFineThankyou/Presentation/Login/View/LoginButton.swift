//
//  LoginButton.swift
//  wineFindThankyou
//
//  Created by mun on 2022/07/23.
//

import UIKit

class LoginButton: UIButton {
    internal var title: String! {
        didSet { self.setTitle(title, for: .normal) }
    }
    internal var titleColor: UIColor! {
        didSet { self.setTitleColor(titleColor, for: .normal) }
    }
    internal var backColor: UIColor! {
        didSet { self.backgroundColor = backColor }
    }
    internal var font: UIFont! {
        didSet { self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17) }
    }
    internal var image: UIImage! {
        didSet {
            let imgView = UIImageView()
            self.addSubViews(imgView)
            NSLayoutConstraint.activate([
                imgView.leftAnchor.constraint(equalTo: self.leftAnchor,
                                             constant: 23),
                imgView.widthAnchor.constraint(equalToConstant: 18),
                imgView.heightAnchor.constraint(equalToConstant: 18),
                imgView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
            imgView.image = image
            imgView.contentMode = .scaleAspectFit
        }
    }
}
