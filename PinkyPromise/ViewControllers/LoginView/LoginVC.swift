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
import AppleSignIn

class LoginVC: UIViewController, FUIAuthDelegate, AppleLoginDelegate {
    func didCompleteAuthorizationWith(user: AppleUser) {
        print(user)
    }
    
    func didCompleteAuthorizationWith(error: Error) {
        print(error)
    }
    
    
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
        //FirebaseAuthentication.shared.signInWithAnonymous()
       
        let button = AppleLoginButton()
        button.delegate = self
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        
        NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
    
    @IBAction func signInWithAppleTapped() {
           guard let window = view.window else { return }
           
           let appleLoginManager = AppleLoginManager()
           appleLoginManager.delegate = self
           
           appleLoginManager.performAppleLoginRequest(in: window)
       }

}
