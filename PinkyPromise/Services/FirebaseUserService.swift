//
//  FirebaseService.swift
//  DAR_Demo
//
//  Created by Dariga Akhmetova on 8/22/19.
//  Copyright © 2019 Dariga Akhmetova. All rights reserved.
//

import Foundation
import FirebaseUI
import FirebaseAuth
import GoogleSignIn
import FirebaseDatabase
import FirebaseStorage

class FirebaseUserService {
    static func signIn_(withEmail email: String, password: String, success: @escaping() -> Void, failure: @escaping(Error) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if error != nil {
                failure(error!)
                return
            }
            success()
        }
    }
    
    static func signUp(withEmail email: String, password: String, username: String, image: UIImage?, defaultCheck: Bool, success: @escaping() -> Void, failure: @escaping(Error) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if error != nil {
                failure(error!)
                return
            }
            let userID = authDataResult?.user.uid
            
            if let chosenImage = image {
                guard let imageData = chosenImage.jpegData(compressionQuality: 0.05) else {
                    return
                }
                //아직 구현단계 여기서는 뭘해야하는지모르겠군
                if defaultCheck == true { // true면 바뀐 이미지가 들어간다. 따라서 userTable에도 그냥 UID가 들어간다.
                    FirebaseStorageService.shared.storeUserImage(image: imageData, completion: { result in
                        switch result {
                        case .failure(let err):
                            print(err)
                        case .success:
                            success()
                        }
                    })
                } else {
                    success()
                }
                
                //또한 여기서 사용자를 만들어야하는듯하다
            }
            else {
                print("this is FirebaseUserService. here is signUp else part.")
            }
        }
    }
    
    static func signOut(success: @escaping() -> Void, failure: @escaping(Error) -> Void){
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance()?.signOut()
            
            UserDefaults.standard.set(false, forKey: "loggedIn")
            
//            if UserDefaults.standard.bool(forKey: "loggedIn") == false {
//
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let tempVC = storyboard.instantiateViewController(withIdentifier: "loginSB") as! UINavigationController
//                tempVC.modalPresentationStyle = .fullScreen
//
//                print("finished")
//            }
            
        }
        catch let signOutError {
            failure(signOutError)
        }
        success()
    }
    
    static func resetPassword(success: @escaping() -> Void, failure: @escaping(Error) -> Void){
        Auth.auth().sendPasswordReset(withEmail: (Auth.auth().currentUser?.email)!) { (error) in
            if error != nil {
                failure(error!)
            }
            success()
        }
    }
    
    static func forgotPassword(withEmail email: String, success: @escaping() -> Void, failure: @escaping(Error) -> Void){
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error != nil {
                failure(error!)
            }
            success()
        }
    }
    
    static func sendEmailVerification(failure: @escaping(Error) -> Void){
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            if error != nil {
                failure(error!)
            }
        })
    }
    
    static var currentUser: User {
        return Auth.auth().currentUser!
    }
    
    static var currentUserID: String? {
        guard let uid = Auth.auth().currentUser?.uid else {
            return "nil"
        }
        return uid
        
//        if Auth.auth().currentUser!.uid == nil {
//            return "nil"
//        }
//        return Auth.auth().currentUser!.uid
    }
}
