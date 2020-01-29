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
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let unselectedColor = UIColor.appColor.withAlphaComponent(0.5)
        let selectedColor   = UIColor.appColor
        
        self.tabBar.unselectedItemTintColor = unselectedColor
        self.tabBar.tintColor = selectedColor
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
         if UserDefaults.standard.bool(forKey: "loggedIn") == false {
                    print("here is AppDeletage.swift 1")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tempVC = storyboard.instantiateViewController(withIdentifier: "loginSB") as! UINavigationController
            
            self.present(tempVC, animated: true, completion: nil)
        }
    }
    
}
