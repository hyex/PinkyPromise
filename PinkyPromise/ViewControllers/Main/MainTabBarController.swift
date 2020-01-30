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
//                print(douc.friendsName)
//            }
//        }
        
        FirebaseStorageService.shared.getUserImageURLWithName(name: "heji.jpeg") { (result) in
            switch result {
                    case .success(let url):
                        print("\(url)")
                    case .failure(let error):
                        print("this is error")
                        
                    }
        }
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if UserDefaults.standard.bool(forKey: "loggedIn") == false {
            print("here is AppDeletage.swift 1")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tempVC = storyboard.instantiateViewController(withIdentifier: "loginSB") as! UINavigationController
            tempVC.modalPresentationStyle = .fullScreen
            self.present(tempVC, animated: true, completion: nil)
            
            print("finished")
        }
    }
    
}
