//
//  LoginVC.swift
//  PinkyPromise
//
//  Created by apple on 2020/01/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit
import Photos
import FirebaseUI
import FirebaseStorage
import SVProgressHUD
import GoogleSignIn

class LoginVC: UIViewController {
    
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var googleSignInBtn: UIButton!
    @IBOutlet weak var appleSignInBtn: UIButton!
    @IBOutlet weak var anomynousSignbtn: UIButton!
    @IBOutlet weak var pinkyTitle: UILabel!
    
    @IBOutlet weak var bottomView: UIImageView!

    var indicator: UIActivityIndicatorView?
    
    @IBAction func goToSignIn(){
        //performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
    }
    
    @IBAction func goToSignUp(){
        
    }
    
    @IBAction func googleSignIn(){
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func appleSignIn(){
        
    }
    
    @IBAction func anomynousSignIn() {
        Auth.auth().signInAnonymously { (authResult, error) in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let user = authResult?.user else { return }
            let isAnonymous = user.isAnonymous //true
            let uid = user.uid
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator = UIActivityIndicatorView()
        self.pinkyTitle.center.x -= view.bounds.width
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        self.bottomView.clipsToBounds = true
        self.bottomView.layer.cornerRadius = bottomView.frame.height/2
        self.bottomView.clipsToBounds = true
        self.bottomView.frame.size.width = width * 2
        self.bottomView.frame.size.height = height * 2
        
        self.anomynousSignbtn.layer.cornerRadius = 10
        self.signInBtn.layer.cornerRadius = 10
        self.signUpBtn.layer.cornerRadius = 10
        self.appleSignInBtn.layer.cornerRadius = 10
        self.googleSignInBtn.layer.cornerRadius = 10
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.pinkyTitle.center.x += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        //GIDSignIn.sharedInstance()?.delegate = self
    }
}

extension LoginVC: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            //SVProgressHUD.showError(withStatus: error.localizedDescription)
            print(error?.localizedDescription)
        } else {
            //SVProgressHUD.show()
            self.indicator?.startAnimating()
            let fullName = user.profile.name
            let email = user.profile.email
            
            guard let idToken = user.authentication.idToken else { return }
            guard let accessToken = user.authentication.accessToken else { return }
            let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signInAndRetrieveData(with: credentials) { (user, error) in
                if error != nil {
                    //SVProgressHUD.showError(withStatus: error?.localizedDescription)
                    print(error?.localizedDescription)
                }
                let userID = user?.user.uid
                
                //구글 유저를 추가해야한다.
                self.indicator?.stopAnimating()
                //SVProgressHUD.dismiss()
                UserDefaults.standard.set(true, forKey: "loggedIn")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = AddPromiseVC()
            }
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        SVProgressHUD.showError(withStatus: error.localizedDescription)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
}


//FireStoreService
//    func storeUserImage(image: Data, completion: @escaping (Result<String, Error>) -> () ) {
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//        let uuid = UUID()
//        let imageLocation = userFolderRef.child(uuid.description)
//        imageLocation.putData(image, metadata: metadata) { (responseMetadata, error) in
//            if let err = error {
//                completion(.failure(err))
//            } else {
//                imageLocation.downloadURL { (url, error) in
//                    guard error == nil else {
//                        completion(.failure(error!))
//                        return
//                    }
//                    guard let url = url?.absoluteString else {
//                        completion(.failure(error!))
//                        return
//                    }
//                    completion(.success(url))
//                }
//            }
//        }
//    }

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
