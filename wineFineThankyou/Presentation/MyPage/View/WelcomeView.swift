//
//  WelcomeView.swift
//  wineFindThankyou
//
//  Created by mun on 2022/02/19.
//

import Foundation
import UIKit

struct UserInfo {
    let userImage: UIImage
    let userType: String
    let wineType: String
    let userId: String
}

class WelcomeView: UIView {
    var userInfo: UserInfo? {
        didSet {
            updateUI()
        }
    }
    
    private unowned var welcomeLabel: UILabel!
    private unowned var userWineTypeLabel: UILabel!
    private unowned var userIdLabel: UILabel!
    private unowned var userImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(superView: UIView, constant: CGFloat = 44) {
        let welcomeView = UIView()
        let welcomelabel = UILabel()
        let userImageView = UIImageView()
        let userWineTypeLabel = UILabel()
        let userIdLabel = UILabel()
        
        superView.addSubview(welcomeView)
        welcomeView.addSubview(welcomelabel)
        welcomeView.addSubview(userImageView)
        welcomeView.addSubview(userWineTypeLabel)
        welcomeView.addSubview(userIdLabel)
        
        welcomeView.translatesAutoresizingMaskIntoConstraints = false
        welcomelabel.translatesAutoresizingMaskIntoConstraints = false
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userWineTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        userIdLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            welcomeView.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor, constant: constant + 8),
            welcomeView.leftAnchor.constraint(equalTo: superView.leftAnchor, constant: 18),
            welcomeView.rightAnchor.constraint(equalTo: superView.rightAnchor, constant: -18),
            welcomeView.heightAnchor.constraint(equalToConstant: 137),
            
            userImageView.topAnchor.constraint(equalTo: welcomeView.topAnchor, constant: 15),
            userImageView.rightAnchor.constraint(equalTo: welcomeView.rightAnchor, constant: -21),
            userImageView.widthAnchor.constraint(equalToConstant: 72),
            userImageView.heightAnchor.constraint(equalToConstant: 72),
            
            welcomelabel.topAnchor.constraint(equalTo: welcomeView.topAnchor, constant: 27),
            welcomelabel.leftAnchor.constraint(equalTo: welcomeView.leftAnchor, constant: 14),
            welcomelabel.rightAnchor.constraint(equalTo: userImageView.leftAnchor, constant: 14),
            
            userWineTypeLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 4),
            userWineTypeLabel.centerXAnchor.constraint(equalTo: userImageView.centerXAnchor),
            
            userIdLabel.topAnchor.constraint(equalTo: userWineTypeLabel.bottomAnchor),
            userIdLabel.centerXAnchor.constraint(equalTo: userWineTypeLabel.centerXAnchor)
        ])
        
        welcomeView.backgroundColor = UIColor(rgb: 0xE5E0FF)
        welcomeView.layer.cornerRadius = 12
        userImageView.contentMode = .scaleAspectFit
        
        self.welcomeLabel = welcomelabel
        self.userImageView = userImageView
        self.userWineTypeLabel = userWineTypeLabel
        self.userIdLabel = userIdLabel
    }
    
    private func updateUI() {
        guard let userInfo = userInfo else { return }
        self.welcomeLabel.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        self.welcomeLabel.attributedText = "안녕하세요, \(userInfo.userType)님.\n\(userInfo.wineType) 와인을\n즐겨마시는군요!".rangeBoldString(22, range: "\(userInfo.wineType) 와인")
        self.welcomeLabel.textColor = .black
        self.welcomeLabel.numberOfLines = 0
        
        userImageView.image = userInfo.userImage
        userWineTypeLabel.text = userInfo.userType + " 포도알"
        userWineTypeLabel.textColor = UIColor(rgb: 0x1e1e1e)
        userWineTypeLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        userIdLabel.text = "@\(userInfo.userId)"
        userIdLabel.textColor = UIColor(rgb: 0x616161)
        userIdLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
    }
}
