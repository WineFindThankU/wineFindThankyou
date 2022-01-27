//
//  StoreSummaryView.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/27.
//

import Foundation
import UIKit

struct StoreSummaryTopView {
    var storeName: UILabel
    var storeClassification: UILabel
    var rightButton: UIButton
}

class StoreSumamryView: UIView{
    var topView: StoreSummaryTopView?
    var storeButtonView: StoreButtonsView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure(){
        self.backgroundColor = Theme.white.color
        
        let topView = UIView()
        let storeName = UILabel()
        let storeClassification = UILabel()
        let rightButton = UIButton()

        self.addSubview(topView)
        topView.addSubview(storeName)
        topView.addSubview(storeClassification)
        topView.addSubview(rightButton)
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        storeName.translatesAutoresizingMaskIntoConstraints = false
        storeClassification.translatesAutoresizingMaskIntoConstraints = false
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: self.topAnchor),
            topView.leftAnchor.constraint(equalTo: self.leftAnchor),
            topView.rightAnchor.constraint(equalTo: self.rightAnchor),
            topView.heightAnchor.constraint(equalToConstant: 58),
            
            storeName.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            storeName.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 17),
            storeName.widthAnchor.constraint(equalToConstant: 217),
            
            storeClassification.leftAnchor.constraint(equalTo: storeName.rightAnchor, constant: 8),
            storeClassification.centerYAnchor.constraint(equalTo: storeName.centerYAnchor),
            
            rightButton.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: -16),
            rightButton.centerYAnchor.constraint(equalTo: storeName.centerYAnchor),
            rightButton.widthAnchor.constraint(equalToConstant: 24),
            rightButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        self.topView = StoreSummaryTopView(storeName: storeName, storeClassification: storeClassification, rightButton: rightButton)
        self.storeButtonView = setStoreButtonView(superView: self, topView)
    }
}
