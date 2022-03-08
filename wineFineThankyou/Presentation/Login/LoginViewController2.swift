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
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

final class LoginViewController2: UIViewController, EndLoginProtocol {
    func endLogin(_ type: AfterLogin) {
        guard type == .success else {
            return
        }
        
        UserData.isUserLogin = true
        self.goToMain()
    }
    

    var statusCode = 0
    var data: DataClass?
    
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
        button.backgroundColor = UIColor.kakao
        button.layer.cornerRadius = 18
        button.setTitle("카카오로 로그인", for: .normal)
        button.setTitleColor(.kakaoText, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setImage(#imageLiteral(resourceName: "_login_kakao"), for: .normal)
        button.contentHorizontalAlignment = .center
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 55)
        let action = UIAction(handler: { _ in
            self.loginController.loginByKakao()
        })
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    lazy var naverButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.naver
        button.layer.cornerRadius = 18
        button.setTitle("네이버로 로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setImage(#imageLiteral(resourceName: "_login_naver"), for: .normal)
        button.contentHorizontalAlignment = .center
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 55)
        let action = UIAction(handler: { _ in
            self.loginController.loginByNaver()
        })
        return button
    }()
    
    lazy var googleButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 18
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth  = 0.7
        button.setTitle("Google로 로그인", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setImage(#imageLiteral(resourceName: "_login_google"), for: .normal)
        button.contentHorizontalAlignment = .center
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 45)
        let action = UIAction(handler: { _ in
            self.loginController.loginByGoogle()
        })
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    lazy var appleButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 18
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth  = 0.7
        button.setTitle("Apple로 로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setImage(#imageLiteral(resourceName: "_login_apple"), for: .normal)
        button.contentHorizontalAlignment = .center
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 45)
        let action = UIAction(handler: { _ in
            self.loginController.loginByApple()
        })
        button.addAction(action, for: .touchUpInside)
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
    
    func goToMain() {
        guard let vc = UIStoryboard(name: StoryBoard.main.name, bundle: nil).instantiateViewController(withIdentifier: MainViewController.identifier)
                as? MainViewController else { return }
        DispatchQueue.main.async { [weak self] in
            vc.modalTransitionStyle = .flipHorizontal
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true, completion: nil)
        }
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        
        titleImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(169)
            make.leading.trailing.equalToSuperview().inset(100)
        }
        
        subView.snp.makeConstraints { make in
            make.height.equalTo(212)
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
    
    private func showCannotLogin() {
        let alert = UIAlertController(title: "로그인 실패", message: "현재 로그인 할 수 없습니다. 잠시 후 다시 시도해주세요.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            alert.dismiss(animated: false)
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}

