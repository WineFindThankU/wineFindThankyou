//
//  LoginController.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/29.
//

import Foundation
import Alamofire
import NaverThirdPartyLogin
import KakaoSDKAuth
import KakaoSDKUser
import GoogleSignIn
import AuthenticationServices

class LoginController: NSObject {
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
        //MARK: 수진. 아래 조건문 always false.
        // 항상 카카오앱을 열지 않고 웹을 이용합니다.
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
        // Error 403: redirected_client
        /*
         This app is not yet configured to make OAuth requests.
         To do that, set up the app’s OAuth consent screen in the Google Cloud Console https://console.developers.google.com/apis/credentials/consent?project=${your_project_number}
         */
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
        // 로그아웃이나 토큰이 삭제되는 경우
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

//MARK: Google login
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

