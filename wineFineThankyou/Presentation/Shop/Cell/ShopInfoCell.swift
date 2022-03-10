//
//  ShopInfoCell.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/26.
//

import Foundation
import UIKit

enum ShopInfo: Int, CaseIterable{
    case call = 0
    case location = 1
    case time = 2
    case homepage = 3
    var imgName: String {
        switch self {
        case .call:
            return "call"
        case .location:
            return "location"
        case .time:
            return "clock"
        case .homepage:
            return "call"
        }
    }
}

class ShopInfoCell: UITableViewCell{
    var imgView: UIImageView?
    var info: UITextView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        self.contentView.backgroundColor = .clear
        let imageView = UIImageView()
        let info = UITextView()
        
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(info)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        info.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20),
            
            info.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 8),
            info.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 21),
            info.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8.5),
            info.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8.5),
        ])
        self.imgView = imageView
        self.info = info
    }
}
