//
//  LoginViewController2.swift
//  wineFindThankyou
//
//  Created by suding on 2022/03/03.
//

// MARK: 🔥
// MARK:   🔥
// MARK:     🔥
// MARK:       🔥
// MARK:         🔥 TEST용도 입니다.

import UIKit
import SnapKit

final class LoginViewController2: UIViewController {

    lazy var titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LaunchTitle")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var loginController : LoginController = {
        let controller = LoginController(self)
        return controller
    }()
    
    lazy var kakaoButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(named: "kakaoLogin")
        button.setImage(buttonImage, for: .normal)
        button.contentMode = .scaleAspectFill
        let action = UIAction(handler: { _ in
            self.loginController.loginByKakao()
        })
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    lazy var naverButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(named: "naverLogin")
        button.setImage(buttonImage, for: .normal)
        return button
    }()
    
    lazy var googleButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(named: "googleLogin")
        button.setImage(buttonImage, for: .normal)
        return button
    }()
    
    lazy var appleButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(named: "appleLogin")
        button.setImage(buttonImage, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfigure()
        setupUI()
    }
    
    private func setupConfigure() {
        view.addSubview(titleImageView)
        view.addSubview(subView)
        subView.addSubview(kakaoButton)
        subView.addSubview(naverButton)
        subView.addSubview(googleButton)
        subView.addSubview(appleButton)
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        
        titleImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(169)
            make.leading.trailing.equalToSuperview().inset(100)
        }
        
        subView.snp.makeConstraints { make in
            make.top.equalTo(titleImageView.snp.bottom).offset(180)
            make.leading.trailing.equalToSuperview().inset(25)
            make.bottom.equalToSuperview().inset(52)
            
        }
        kakaoButton.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        naverButton.snp.makeConstraints { make in
            make.top.equalTo(kakaoButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        googleButton.snp.makeConstraints { make in
            make.top.equalTo(naverButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        appleButton.snp.makeConstraints { make in
            make.top.equalTo(googleButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
    }

}

