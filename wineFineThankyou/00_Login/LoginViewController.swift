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

class LoginViewController: UIViewController {
    @IBOutlet weak var buttonKakao: UIButton!
    @IBOutlet weak var buttonGoogle: UIButton!
    var naverConnection : NaverThirdPartyLoginConnection?
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
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
