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
                        self.getLoginSNS(loginId: email, snsID: nickname, authType: "kakao")
                        self.loginController.presentToMain()
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
                self.getLoginSNS(loginId: email, snsID: nickname, authType: "kakao")
                self.loginController.presentToMain()
            }
        }
    }
    
    func getLoginSNS(loginId: String, snsID: String, authType: String) {
        let url = "http://125.6.36.157:3001/v1/auth/sign"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        let params = ["id":"\(loginId)",
                      "sns_id":"\(snsID)",
                      "type":"\(authType)"] as Dictionary
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        AF.request(request).responseJSON {(response) in
             switch response.result {
             case .success(let item):
                 if let nsDictionary = item as? NSDictionary {
                     do {
                         let dataJSON = try JSONSerialization.data(withJSONObject: item, options: .prettyPrinted)
                         let getData = try JSONDecoder().decode(LoginResponse.self, from: dataJSON)
                         UserDefaults.standard.set(getData.data.accessToken, forKey: "accessToken")
                     } catch {
                         print("error")
                     }
                 }
             case .failure(let error):
                 print(error)
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
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            print("\(String(describing: appleIDCredential.fullName))")
            print("\(String(describing: appleIDCredential.fullName))")
            print("User ID : \(userIdentifier)")
            print("User Email : \(email ?? "")")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
            getLoginSNS(loginId: email ?? "wft@gmail.com", snsID: fullName?.givenName ?? "1234", authType: "apple")
            
        default:
            break
        }
        delegate?.endLogin(.success)
       // loginController.goToMain()
    }
        
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        delegate?.endLogin(.fail)
    }
}
