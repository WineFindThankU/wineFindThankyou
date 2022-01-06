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
    
    @IBOutlet weak var buttonGoogle: UIButton!
    
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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    


}
