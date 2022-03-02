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

class LoginController: NSObject {
    let loginResponse: LoginResponse
    private lazy var naverConnection : NaverThirdPartyLoginConnection? = {
        let nConn = NaverThirdPartyLoginConnection.getSharedInstance()
        return nConn
    }()
    
    unowned var vc : UIViewController!
    weak var delegate: EndLoginProtocol?
    
    init(_ vc: UIViewController) {
        super.init()
        
        self.vc = vc
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
        guard UserApi.isKakaoTalkLoginAvailable() else {
                    UserApi.shared.loginWithKakaoAccount {
                        self.delegate?.endLogin(self.logInKakao(token: $0, error: $1))
                    }
                    return
                }
        
                UserApi.shared.loginWithKakaoTalk {
                    self.delegate?.endLogin(self.logInKakao(token: $0, error: $1))
                }
            }
        
            private func logInKakao(token: OAuthToken?, error: Error?) -> AfterLogin {
                if let error = error {
                    print(error)
                    return .fail
                }
        
                _ = token
                _ = token?.accessToken
                return .success
    }
    
    internal func loginByGoogle() {
        //MARK: 수진. 구글오류 아래와 같이 실패합니다. 확인 바랍니다.
        GIDSignIn.sharedInstance()?.signIn()
    }
}

extension LoginController {
  
    func post() {
            // 1. 전송할 값 준비
        let apiURL = "ahttp://125.6.36.157:3001/v1/auth/sign"
        let param: Parameters = [:]
        AF.request(apiURL, method: .post,
                   parameters: param,
                   encoding: URLEncoding.httpBody).responseJSON() { response in
        switch response.result {
        case .success:
            if let jsonObject = try! response.result.get() as? [String: Any] {
                let statusCode = jsonObject["statusCode"] as? String
                let message = jsonObject["message"] as? String
                let DataClass = jsonObject["data"] as? String
                self.loginResponse = response.response?.statusCode
                self.
                    
                case .failure(let error):
                    print(error)
                    return
                }
            }
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
        // 로그인 실패시에 호출되며 실패 이유와 메시지 확인 가능합니다.
        delegate?.endLogin(.fail)
    }
    
    private func naverSDKDidLoginSuccess() {
        Login.shared.loginByNaver(naverConnection)
        delegate?.endLogin(.success)
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
        
        // singleton 객체 - user가 로그인을 하면, AppDelegate.user로 다른곳에서 사용 가능
        AppDelegate.user = user
    }
}

//MARK: Apple login
extension LoginController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.vc.view.window!
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
            print("\(appleIDCredential.fullName)")
            print("\(appleIDCredential.fullName)")
            print("User ID : \(userIdentifier)")
            print("User Email : \(email ?? "")")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
     
        default:
            break
        }
        delegate?.endLogin(.success)
    }
        
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        delegate?.endLogin(.fail)
    }
}

