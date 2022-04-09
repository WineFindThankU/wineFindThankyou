//
//  AppDelegate.swift
//  wineFineThankyou
//
//  Created by on 2022/01/04.
//

import UIKit
import KakaoSDKCommon
import GoogleSignIn
import NaverThirdPartyLogin
import KakaoSDKAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
    // User 정보를 서버로 부터 가져올경우 다음 싱글톤 객체 사용 (user.profile.suerId 등등)
    public static var user: GIDGoogleUser!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        // MARK: Kakao 로그인
        KakaoSDK.initSDK(appKey: "d9e14f140e99e729ceb0aada8dde9677")
        
        // MARK: Google 로그인
        // FirebaseApp.configure()
        GIDSignIn.sharedInstance()?.clientID = "824951586402-6sessam73hmlrg01dpggfotfjkot26kv.apps.googleusercontent.com"
        
        // MARK: Naver 로그인
        setLogin2Naver()
        
        NWMonitor.shared.start()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options)
        
        return (GIDSignIn.sharedInstance()?.handle(url))!
    }
    
    
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func setLogin2Naver() {
        //MARK: login naver
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
    
        instance?.isNaverAppOauthEnable = true
        instance?.isInAppOauthEnable = true
        instance?.isOnlyPortraitSupportedInIphone()
        
        instance?.serviceUrlScheme = kServiceAppUrlScheme
        instance?.consumerKey = kConsumerKey
        instance?.consumerSecret = kConsumerSecret
        instance?.appName = kServiceAppName
    }
}

