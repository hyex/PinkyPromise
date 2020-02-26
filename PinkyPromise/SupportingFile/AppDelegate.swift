//
//  AppDelegate.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/12/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import GoogleSignIn
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let notificationCenter = UNUserNotificationCenter.current()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        FirebaseApp.configure()
        Firestore.firestore().settings.isPersistenceEnabled = true
        Firestore.firestore().settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
        
        //        let store = Firestore.firestore()
        //
        //        let setting = FirestoreSettings()
        //        setting.isPersistenceEnabled = true
        //        setting.cacheSizeBytes = FirestoreCacheSizeUnlimited
        //
        //        store.settings = setting
        //
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        
        notificationCenter.delegate = self
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            
            print("in openurl options")
            if KLKTalkLinkCenter.shared().isTalkLinkCallback(url) {
                let params = url.query
                print("카카오링크 메시지 액션\n\(params ?? "파라미터 없음")")
                UIAlertController.showMessage("카카오링크 메시지 액션\n\(params ?? "파라미터 없음")")
            }
            
            return GIDSignIn.sharedInstance().handle(url)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print("in openurl source")
        if KLKTalkLinkCenter.shared().isTalkLinkCallback(url) {
            let params = url.query
            print("카카오링크 메시지 액션\n\(params ?? "파라미터 없음")")
            UIAlertController.showMessage("카카오링크 메시지 액션\n\(params ?? "파라미터 없음")")
        }
        
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
    
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        UIApplication.shared.applicationIconBadgeNumber = 0
//    }
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.identifier == "Local Notification" {
            print("Handling notifications with the Local Notification Identifier")
        }
        
        completionHandler()
    }
    
    func scheduleNotification() {
        
        let content = UNMutableNotificationContent() // Содержимое уведомления
        let categoryIdentifire = "Delete Notification Type"
        
        content.title = "오늘의 약속은 모두 지키셨나요?"
        content.body = "지금 바로 약속을 지켰는지 기록하고, 친구들의 약속 지킴 여부도 확인하세요!"
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = categoryIdentifire
        
        
        let date = Date()
        var triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
        triggerDaily.hour = 22
        triggerDaily.minute = 00
        triggerDaily.second = 00
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)

//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
        let actionA = UNNotificationAction(identifier: "ActionA", title: "Action A", options: [])
        let actionB = UNNotificationAction(identifier: "ActionB", title: "Action B", options: [])
        let category = UNNotificationCategory(identifier: categoryIdentifire,
                                              actions: [actionA, actionB],
                                              intentIdentifiers: [],
                                              options: [])
        
        notificationCenter.setNotificationCategories([category])
    }
}
