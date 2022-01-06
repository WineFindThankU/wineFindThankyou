//
//  LoginViewController.swift
//  wineFineThankyou
//
//  Created by on 2022/01/06.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser


class LoginViewController: UIViewController {

    @IBOutlet weak var buttonKakao: UIButton!
    
    @IBAction func onClickKakao(_ sender: Any) {
        // 카카오톡 설치 여부 확인
          if (UserApi.isKakaoTalkLoginAvailable()) {
            // 카카오톡 로그인. api 호출 결과를 클로저로 전달.
              UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    // 예외 처리 (로그인 취소 등)
                    print(error)
                } else {
                    print("loginWithKakaoTalk() success.")
                   // do something
                    _ = oauthToken
                   let accessToken = oauthToken?.accessToken
                }
            }
          } else {
              UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                 if let error = error {
                   print(error)
                 }
                 else {
                  print("loginWithKakaoAccount() success.")
                  
                  //do something
                  _ = oauthToken
                 }
              }
          }
        }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    


}
