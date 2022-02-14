//
//  LoginViewController.swift
//  wineFineThankyou
//
//  Created by on 2022/01/06.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser
import GoogleSignIn
import NaverThirdPartyLogin
import AuthenticationServices

struct UsersWineType : Codable {
    let question1 : String
    let question2: String
    let question3: String
}

enum AfterLogin {
    case success
    case fail
    case cannotAccess
    
    //TEST
    var str: String{
        switch self {
        case .success:
            return "로그인 성공"
        case .fail:
            return "로그인 실패"
        case .cannotAccess:
            return "나이가 어려요"
        }
    }
    
    var detail: String {
        switch self {
        case .success:
            return ""
        case .fail:
            return "인증 문제로 로그인 할 수 없습니다. 개발자에게 화를 내주세요."
        case .cannotAccess:
            let alert = AlertViewController()
            return "애들은 가라, 애들은 가.🤬"
        }
    }
}
protocol EndLoginProtocol: AnyObject {
    func endLogin(_ type: AfterLogin)
}
class LoginViewController: UIViewController {
    @IBOutlet weak var buttonKakao: UIButton!
    @IBOutlet weak var buttonGoogle: UIButton!
    @IBOutlet weak var appleSignInButton: UIButton!
    
    lazy var loginController : LoginController = {
        let con = LoginController(self)
        con.delegate = self
        return con
    }()

    @IBAction func onClickKakao(_ sender: Any) {
        loginController.loginByKakao()
    }
    @IBAction func onClickGoogle(_ sender: Any) {
        loginController.loginByGoogle()
    }
    @IBAction func onClickNaver(_ sender: UIButton){
        loginController.loginByNaver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        GIDSignIn.sharedInstance().presentingViewController = self
    }
    
    private func configure() {
        let authorizationButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        authorizationButton.cornerRadius = .maximum(20, 20)
        authorizationButton.addTarget(self, action: #selector(appleSignInButtonPress), for: .touchUpInside)
        self.appleSignInButton.addSubview(authorizationButton)
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authorizationButton.topAnchor.constraint(equalTo: self.appleSignInButton.topAnchor),
            authorizationButton.bottomAnchor.constraint(equalTo: self.appleSignInButton.bottomAnchor),
            authorizationButton.leadingAnchor.constraint(equalTo: self.appleSignInButton.leadingAnchor),
            authorizationButton.trailingAnchor.constraint(equalTo: self.appleSignInButton.trailingAnchor)
        ])
    }
}
extension LoginViewController: EndLoginProtocol{
    func endLogin(_ type: AfterLogin) {
        switch type {
        case .success:
            UserData.isUserLogin = true
            goToMain()
        default:
            //TEST
            makeAlert(type: type)
        }
    }
    
    func goToMain() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else { return }
        
        DispatchQueue.main.async { [weak self] in
            vc.modalTransitionStyle = .flipHorizontal
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true, completion: nil)
        }
    }
    
    func makeAlert(type: AfterLogin) {
        let alert = UIAlertController(title: type.str, message: type.detail, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel){ _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
extension LoginViewController {
    @objc
    private func appleSignInButtonPress() {
        loginController.loginByApple()
    }
}
