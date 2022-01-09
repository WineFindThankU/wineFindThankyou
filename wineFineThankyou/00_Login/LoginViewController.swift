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
import Alamofire
import AuthenticationServices

class LoginViewController: UIViewController {
    @IBOutlet weak var buttonKakao: UIButton!
    @IBOutlet weak var buttonGoogle: UIButton!
    @IBOutlet weak var appleSignInButton: UIButton!
    
    private var naverConnection : NaverThirdPartyLoginConnection?
    // MARK: 카카오 로그인
    @IBAction func onClickKakao(_ sender: Any) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoTalk() 성공")
                    _ = oauthToken
                    _ = oauthToken?.accessToken
                }
            }
        } else { // 카카오톡 안깔려있을 때
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() 성공")
                    _ = oauthToken
                }
            }
        }
    }
    
    // MARK: 구글 로그인
    @IBAction func onClickGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func onClickNaver(_ sender: UIButton){
        naverConnection = NaverThirdPartyLoginConnection.getSharedInstance()
        naverConnection?.delegate = self
        naverConnection?.requestThirdPartyLogin()
    }
    
    // Apple ID 로그인 버튼 생성
    func setAppleSignInButton() {
        let authorizationButton = ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline)
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
    
    // Apple Login Button Pressed
    @objc func appleSignInButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
            
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        setAppleSignInButton()
    }
}

//TODO: (문용) 추후 분리 예정
extension LoginViewController: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        // 로그인이 성공했을 경우 호출
        naverSDKDidLoginSuccess()
    }
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        // 이미 로그인이 되어있는 경우 access 토큰을 업데이트 하는 경우
        naverSDKDidLoginSuccess()
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        // 로그아웃이나 토큰이 삭제되는 경우
        naverConnection?.requestDeleteToken()
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        // 로그인 실패시에 호출되며 실패 이유와 메시지 확인 가능합니다.
    }
    
    // TODO: (문용) 추후 분리 필요.
    private func naverSDKDidLoginSuccess() {
        guard let isValidAccessToken = naverConnection?.isValidAccessTokenExpireTimeNow() else { return }
        
        if !isValidAccessToken {
            print("InvalidAccessToken")
            return
        }
        
        guard let tokenType = naverConnection?.tokenType else { return }
        guard let accessToken = naverConnection?.accessToken else { return }
        
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
        
        let authorization = "\(tokenType) \(accessToken)"
        
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        
        req.responseJSON { response in
            guard let result = response.value as? [String: Any] else { return }
            print("result")
            //TODO: result dictionary. 추후 localDB저장 혹은 서버 전송할 데이터
        }
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            // 계정 정보 가져오기
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
                
            print("User ID : \(userIdentifier)")
            print("User Email : \(email ?? "")")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
     
        default:
            break
        }
    }
        
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}
