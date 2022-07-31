//
//  LoginViewController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/07/23.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

final class LoginViewController: UIViewController {
    private lazy var loginController: LoginController = {
        let lController = LoginController(self)
        return lController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        self.view.backgroundColor = .white
        
        let imageView = UIImageView()
        self.view.addSubViews(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                                           constant: 129),
            imageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 100),
            imageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -100),
            imageView.heightAnchor.constraint(equalToConstant: 70),
        ])
        imageView.image = UIImage(named: "LaunchTitle")
        imageView.contentMode = .scaleAspectFit

        let loginBtnSuperView = UIView()
        self.view.addSubViews(loginBtnSuperView)
        NSLayoutConstraint.activate([
            loginBtnSuperView.heightAnchor.constraint(equalToConstant: 212),
            loginBtnSuperView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                                                      constant: -52),
            loginBtnSuperView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            loginBtnSuperView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
        ])

        let kakaoButton = LoginButton()
        loginBtnSuperView.addSubViews(kakaoButton)
        let googleButton = LoginButton()
        loginBtnSuperView.addSubViews(googleButton)
        let appleButton = LoginButton()
        loginBtnSuperView.addSubViews(appleButton)
        
        [kakaoButton, googleButton, appleButton].forEach {
            $0.leftAnchor.constraint(equalTo: loginBtnSuperView.leftAnchor,
                                     constant: 25).isActive = true
            $0.rightAnchor.constraint(equalTo: loginBtnSuperView.rightAnchor,
                                      constant: -25).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 44).isActive = true
            $0.layer.cornerRadius = 22
        }
        NSLayoutConstraint.activate([
            appleButton.bottomAnchor.constraint(equalTo: loginBtnSuperView.bottomAnchor),
            googleButton.bottomAnchor.constraint(equalTo: appleButton.topAnchor, constant: -12),
            kakaoButton.bottomAnchor.constraint(equalTo: googleButton.topAnchor, constant: -12)
        ])
        
        kakaoButton.image = UIImage(named: "_login_kakao")
        kakaoButton.title = "카카오로 로그인"
        kakaoButton.titleColor = UIColor(rgb: 0x191919)
        kakaoButton.backColor = UIColor(rgb: 0xFEE500)
        kakaoButton.addAction(UIAction { [weak self] _ in
            self?.loginController.loginByKakao()
        }, for: .touchUpInside)
        
        googleButton.image = UIImage(named: "_login_google")
        googleButton.title = "Google로 로그인"
        googleButton.titleColor = UIColor(rgb: 0x000000)
        googleButton.backColor = UIColor(rgb: 0xFFFFFF)
        googleButton.layer.borderWidth = 1
        googleButton.layer.borderColor = UIColor(rgb: 0xEEEEEE).cgColor
        googleButton.addAction(UIAction { [weak self] _ in
            self?.loginController.loginByGoogle()
        }, for: .touchUpInside)
        
        appleButton.image = UIImage(named: "_login_apple")
        appleButton.title = "Apple로 로그인"
        appleButton.titleColor = .white
        appleButton.backColor = .black
    }
    
    private func goToMain() {
        guard let vc = UIStoryboard(name: StoryBoard.main.name, bundle: nil).instantiateViewController(withIdentifier: MainViewController.identifier)
                as? MainViewController else { return }
        DispatchQueue.main.async { [weak self] in
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true, completion: nil)
        }
    }
    
    private func showCannotLogin() {
        let alert = UIAlertController(title: "로그인 실패",
                                      message: "현재 로그인 할 수 없습니다. 잠시 후 다시 시도해주세요.",
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            alert.dismiss(animated: false)
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController: EndLoginProtocol {
    func endLogin(_ type: AfterLogin) {
        guard type == .success else {
            return
        }
        
        UserData.isUserLogin = true
        self.goToMain()
    }
}
