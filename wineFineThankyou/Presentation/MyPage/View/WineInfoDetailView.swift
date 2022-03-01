//
//  WineInfoDetailView.swift
//  wineFindThankyou
//
//  Created by mun on 2022/03/01.
//

import UIKit

class WineInfoDetailView: UIView {
    let superView = UIView()
    private weak var title: UILabel!
    private weak var content: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        let title = UILabel()
        let content = UILabel()
        superView.translatesAutoresizingMaskIntoConstraints = false
        superView.addSubViews(subViews: title, content)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: superView.topAnchor),
            title.leftAnchor.constraint(equalTo: superView.leftAnchor),
            title.widthAnchor.constraint(equalToConstant: 36),
            title.bottomAnchor.constraint(equalTo: superView.bottomAnchor),
            
            content.topAnchor.constraint(equalTo: superView.topAnchor),
            content.leftAnchor.constraint(equalTo: title.rightAnchor, constant: 8),
            content.rightAnchor.constraint(equalTo: superView.rightAnchor, constant: -20),
            content.bottomAnchor.constraint(equalTo: superView.bottomAnchor),
        ])
        
        title.textColor = UIColor(rgb: 0x9e9e9e)
        title.font = UIFont.systemFont(ofSize: 11)
        
        content.textColor = UIColor(rgb: 0x424242)
        content.font = UIFont.systemFont(ofSize: 11)
        
        self.title = title
        self.content = content
    }
    
    func updateInfo(_ title: String, _ content: String) {
        self.title.text = title
        self.content.text = content
    }
}
