//
//  AppDelegate.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/12/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        //로그인이 되어있지않은경우
//        window?.rootViewController = UIViewController()
        if UserDefaults.standard.bool(forKey: "loggedIn") == false {
            print("here is AppDeletage.swift 1")

            //스토리보드 identifier 설정
            //let tempstory = main.storyboard -> 신 가져오기
            //let tempvc = tempstory as LoginVC
            //initalViewController = tempcv
            let initialViewController = LoginVC()
            //initialViewController.isNavigationBarHidden = true
            window?.rootViewController = initialViewController
            //로그인이 되어있는경우는 바로 뷰컨트롤러를 메인탭바로 이동하고싶은데 하루종일삽질했는데 안된다.

        }//로그인이 되어있는경우
        else if UserDefaults.standard.bool(forKey: "loggedIn") == true {
            print("here is AppDeletage.swift 2")

            let initialViewController = MainTabBarController()
            //initialViewController.isNavigationBarHidden = true
            window?.rootViewController = initialViewController
        }

        FirebaseApp.configure()
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        
        return true
    }

    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
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


}

