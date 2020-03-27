//
//  MainTabBarController.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/13/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // 나중에 user 전역 어쩌고에 사용
    //    var data:String? = nil
    
    var thoughtuser = [PromiseUser]()
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appDelegate?.scheduleNotification()
        
        let unselectedColor = UIColor.appColor.withAlphaComponent(0.5)
        let selectedColor   = UIColor.appColor
        
        self.tabBar.unselectedItemTintColor = unselectedColor
        self.tabBar.tintColor = selectedColor
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        
        
//        if UserDefaults.standard.bool(forKey: "appleLogin") == true {
//            self.showAlertPWResetController(style: UIAlertController.Style.alert)
//            UserDefaults.standard.set(false, forKey: "appleLogin")
//        }
        
        //        let temp = PromiseTable(promiseName: "테스트테스트1", promiseStartTime: Date(timeIntervalSince1970: 1579989600), promiseEndTime: Date(timeIntervalSince1970: 1581199200), promiseColor: "blueblack", promiseIcon: "maybe", promiseUsers: [ "xF2R2vcXdhdY1PutfR7yTeTE6542", "Z42iyamWUEMXnPcOi0iwPRrGU4q1" ], isPromiseAchievement: false, promisePanalty: "벌칙벌칙", promiseId: MyApi.shared.randomNonceString() )
        //
        //        MyApi.shared.addPromiseData(temp)
        //        MyApi.shared.addProgressData(temp)
        //        print("test")
        
        //        var temp = [PromiseTable]()
        //
        //        //예시 데이터 물어보기
        //            MyApi.shared.getCompletedPromiseData { (result) in
        //                print("testing...")
        //                temp = result
        //            }
        //
        //
        //            MyApi.shared.getPerfectCompletedPromiseData(promises: temp) { (temp2) in
        //                print("testing2...")
        //                for douc in temp2 {
        //                    print(douc.promiseName)
        //                    print(douc.promiseColor)
        //                    print(douc.promisePanalty)
        //                }
        //            }
        
        
//                MyApi.shared.getCompletedPromiseData { (result) in
//                    print(result)
//                }
        
//        MyApi.shared.getPromiseNameAndFriendsName { (result) in
//            for douc in result {
//                print(douc.promiseId)
//                print(douc.promiseName)
//                print(douc.FirstuserImage)
//                print(douc.friendsName)
//            }
//        }
        
 //       print ( MyApi.shared.getTotalDate() )
        
//        MyApi.shared.getDataforDetailViewjr1(promiseID: "8ttBEtiVlShS038GHvlI") { (result) in
//            print(result.promiseName)
//            print(result.promiseDay)
//            print(result.promiseDaySinceStart)
//
//            for douc in result.friendsDetail {
//                print(douc.friendName)
//                print(douc.friendDegree)
//                print(douc.friendImage)
//            }

//        }
        
//        print("teset")
//        MyApi.shared.getMothlyDataWithCurrentMonth { result in
//            for douc in result {
//                print("test")
//                print(douc.Day)
//                for douc2 in douc.promiseData {
//                    print(douc2.promiseName)
//                }
//                for douc2 in douc.progressData {
//                    print(douc2.progressDegree)
//                }
//            }
//        }
//
//        }

//        MyApi.shared.getDataforDetailViewjr1(promiseID: "8ttBEtiVlShS038GHvlI") { (result) in
//            print(result.promiseName)
//            print(result.promiseDay)
//            print(result.promiseDaySinceStart)
//
//            for douc in result.friendsDetail {
//                print(douc.friendName)
//                print(douc.friendDegree)
//                print(douc.friendImage)
//            }
//        }

        
//        var temp = PromiseTable(promiseName: "iOS 관두기", promiseStartTime: Date(timeIntervalSince1970: 1580428800 - 86400), promiseEndTime: Date(timeIntervalSince1970: 1580428800 + 86400), promiseColor: "Red", promiseIcon: "imacicon", promiseUsers: [], isPromiseAchievement: false, promisePanalty: "Android 시작하기", promiseId: MyApi.shared.randomNonceString())
//
//        MyApi.shared.addPromiseData(temp)

//        MyApi.shared.getUsersFriendsData { (result) in
//            for douc in result {
//                print(douc.userId)
//                print(douc.documentId)
//                print(douc.userImage)
//            }
//        }

        //firebase storage storeimage 사용예시
        //    guard let imageData = self.image?.jpegData(compressionQuality: 1) else {
        //        makeAlert(with: "error", and: "could not compress image")
        //        return
        //    }
        //
        //    FirebaseStorageService.shared.storeUserImage(image: imageData) { [weak self] (result) in
        //        switch result {
        //        case .success(let url):
        //            self?.imageURL = url
        //            print("check 3")
        //            print(self?.imageURL)
        //        case .failure(let error):
        //            print("this is error")
        //            print(error)
        //        }
        //    }
        
//               let temp = PromiseTable(promiseName: "테스트테스트1", promiseStartTime: Date(timeIntervalSince1970: 1579989600), promiseEndTime: Date(timeIntervalSince1970: 1581199200), promiseColor: "blueblack", promiseIcon: "maybe", promiseUsers: [ "xF2R2vcXdhdY1PutfR7yTeTE6542", "Z42iyamWUEMXnPcOi0iwPRrGU4q1", ], isPromiseAchievement: true, promisePanalty: "벌칙벌칙", promiseId: MyApi.shared.randomNonceString() )
//
//        MyApi.shared.addPromiseData(temp)
//        MyApi.shared.addProgressData(temp)
        
//        MyApi.shared.getAllHome { (result) in
//                   print("test")
//                   for douc in result {
//                       print(douc.Day)
//                       for douc2 in douc.PAPD {
//                           print(douc2.progressData.promiseId)
//                           print(douc2.promiseData.promiseName)
//                       }
//                    }
//               }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "loggedIn") == false {
            print("here is MainTabBarController")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tempVC = storyboard.instantiateViewController(withIdentifier: "loginSB") as! UINavigationController
            tempVC.modalPresentationStyle = .fullScreen
            self.present(tempVC, animated: true, completion: nil)
            
            print("finished")
        }

    }
    
}
