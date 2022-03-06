//
//  LoginController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/29.
//

import Foundation
import Alamofire
import NaverThirdPartyLogin
import KakaoSDKUser
import KakaoSDKAuth
import GoogleSignIn
import AuthenticationServices
import SwiftyJSON

enum NetworkError: Error {
    case badUrl
    case noData
    case decodingError
}


class LoginController: NSObject {
    
    lazy var loginController : LoginViewController2 = {
        let controller = LoginViewController2()
        return controller
    }()
    
    private lazy var naverConnection : NaverThirdPartyLoginConnection? = {
        let nConn = NaverThirdPartyLoginConnection.getSharedInstance()
        return nConn
    }()
    
    unowned var viewController : UIViewController!
    weak var delegate: EndLoginProtocol?
    
    init(_ viewController: UIViewController) {
        super.init()
        self.viewController = viewController
        self.delegate = viewController as? EndLoginProtocol
        
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    internal func loginByNaver() {
        naverConnection?.delegate = self
        naverConnection?.requestThirdPartyLogin()
    }
    
    internal func loginByApple() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    

    
    internal func loginByKakao() {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                    print(error)
            } else {
                UserApi.shared.me() {(user, error) in
                    if let error = error {
                        print(error)
                    } else {
                        _ = user
                        let email = user?.kakaoAccount?.email ?? ""
                        let nickname = user?.kakaoAccount?.profile?.nickname ?? ""
                        print(email)
                        print(nickname)
                        AFHandler.getLoginSNS(loginId: email, snsID: nickname, authType: "kakao") {
                            self.delegate?.endLogin($0)
                        }
                    }
                }
            }
        }
    }
    
    func setUserInfo() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            } else {
                _ = user
                let email = user?.kakaoAccount?.email ?? ""
                let nickname = user?.kakaoAccount?.profile?.nickname ?? ""
                print(email)
                print(nickname)
                AFHandler.getLoginSNS(loginId: email, snsID: nickname, authType: "kakao") {
                    self.delegate?.endLogin($0)
                }
            }
        }
    }
    
    internal func loginByGoogle() {
        GIDSignIn.sharedInstance()?.signIn()
    }
}


//MARK: Naver login
extension LoginController: NaverThirdPartyLoginConnectionDelegate{
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        naverSDKDidLoginSuccess()
        delegate?.endLogin(.success)
    }
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        naverSDKDidLoginSuccess()
        delegate?.endLogin(.success)
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        naverConnection?.requestDeleteToken()
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        delegate?.endLogin(.fail)
    }
    
    private func naverSDKDidLoginSuccess() {
        Login.shared.loginByNaver(naverConnection)
        delegate?.endLogin(.success)
        RequestNetworking.getLoginCheckAPI()
    }
}

// MARK: Google login
extension LoginController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if(error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("not signed in before or signed out")
            } else {
                print(error.localizedDescription)
            }
            
            delegate?.endLogin(.fail)
        } else {
            delegate?.endLogin(.success)
        }
        AppDelegate.user = user
    }
}

//MARK: Apple login
extension LoginController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.viewController.view.window!
    }
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = String(describing: appleIDCredential.fullName)
            let nick = fullName.isEmpty ? "User" : fullName
            let email = appleIDCredential.email ?? "WTFUser@wineThankU.com"
            let type = "apple"
            
            let params = [
                "id": email,
                "type": type,
                "sns_id": userIdentifier,
                "nick": nick,
                "taste_type": 1,
                "taste_data": [
                    "1": [
                        "value": "1"
                    ],
                    "2": [
                        "value": "2"
                    ],
                    "3": [
                        "value": "-1",
                        "etc": "only 소주"
                    ]
                ],
            ] as [String : Any]
            AFHandler.signBySNS(params) {
                guard $0 == AfterSign.success else {
                    return
                }
                
                AFHandler.getLoginSNS(loginId: email, snsID: userIdentifier, authType: type) {
                    self.delegate?.endLogin($0)
                }
            }
            
        default:
            delegate?.endLogin(.fail)
            break
        }
    }
        
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        delegate?.endLogin(.fail)
    }
}
