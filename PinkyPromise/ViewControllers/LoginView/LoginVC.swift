//
//  LoginVC.swift
//  PinkyPromise
//
//  Created by apple on 2020/01/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit
import FirebaseUI
import GoogleSignIn

class LoginVC: UIViewController, FUIAuthDelegate   {
    
    
//    fileprivate var _authHandle: AuthStateDidChangeListenerHandle!
//    var user: FIRUser?
    let authUI = FUIAuth.defaultAuthUI()
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let providers: [FUIAuthProvider] = [
                FUIGoogleAuth(),
        ]
        authUI!.providers = providers
       
        //google login
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
}

extension LoginVC: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            print("login success")
            return
        }else {
            print("\(error.localizedDescription)")
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        //perform..
    }
}
