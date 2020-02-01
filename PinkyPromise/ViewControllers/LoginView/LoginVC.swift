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
//import SVProgressHUD
import GoogleSignIn
import AuthenticationServices

class LoginVC: UIViewController {
    
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var googleSignInBtn: UIButton!
    @IBOutlet weak var appleSignInBtn: UIButton!
    @IBOutlet weak var pinkyTitle: UILabel!
    
    @IBOutlet weak var bottomView: UIImageView!
    @IBOutlet weak var tempImage: UIImageView!
    
    var indicator: UIActivityIndicatorView?
    var currentNonce: String? = nil
    
    @IBAction func goToSignIn(){
        let controller = signInVC()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func goToSignUp(){
        
    }
    
    @IBAction func googleSignIn(){
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func appleSignIn(){
        self.currentNonce = API.shared.startSignInWithAppleFlow(vc: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator = UIActivityIndicatorView()
//        self.pinkyTitle.center.x -= view.bounds.width
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        self.bottomView.clipsToBounds = true
        self.bottomView.layer.cornerRadius = bottomView.frame.height/2
        self.bottomView.clipsToBounds = true
        self.bottomView.frame.size.width = width * 2
        self.bottomView.frame.size.height = height * 2

        self.signInBtn.layer.cornerRadius = 10
        self.signUpBtn.layer.cornerRadius = 10
        self.appleSignInBtn.layer.cornerRadius = 10
        self.googleSignInBtn.layer.cornerRadius = 10

        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.pinkyTitle.center.x += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        
//        print(Auth.auth().currentUser?.email ?? "")

        var temp3 = [String]()
        var temp4 = [[PromiseTable]]()
        
//        MyApi.shared.getPromiseDataSorted { (temp4) in
//            for douc1 in temp4 {
//                print("this is douc1...")
//                for douc2 in douc1 {
//                    print("this is douc2.. +\(douc2.promiseName) + \(douc2.promiseColor)" )
//                }
//            }
//        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier)
        
        switch segue.identifier {
        case "loginSegue":
            let mainVC = segue.destination as! MainTabBarController
        default:
            break
        }
    }
}

extension LoginVC: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            //SVProgressHUD.showError(withStatus: error.localizedDescription)
            print(error?.localizedDescription)
        } else {
            //SVProgressHUD.show()
            //self.indicator?.startAnimating()
            let fullName = user.profile.name
            let email = user.profile.email
            
            guard let idToken = user.authentication.idToken else { return }
            guard let accessToken = user.authentication.accessToken else { return }
            let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signIn(with: credentials) { (user, error) in
                if error != nil {
                    //SVProgressHUD.showError(withStatus: error?.localizedDescription)
                    print(error?.localizedDescription ?? "")
                }
                
                let userID = user?.user.uid
                
                self.indicator?.stopAnimating()
                //SVProgressHUD.dismiss()
                //let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                print(fullName)
                print(email)
                
                //signin을 만들어서 더 추가하면됨
                if UserDefaults.standard.bool(forKey: "loggedIn") == false || UserDefaults.standard.bool(forKey: "signedIn") == false {
                    print("not yet logined...")
                    self.navigationController?.isNavigationBarHidden = true
                    UserDefaults.standard.set(true, forKey: "loggedIn")
                    
                    let temp = PromiseUser(userName: fullName!, userFriends: [], userId: userID!, userImage: userID!, userCode: Int.random(in: 100000...999999), documentId: MyApi.shared.randomNonceString())
                    MyApi.shared.addUserData(temp)
                    
                    if UserDefaults.standard.bool(forKey: "signedIn") == false{
                        let tempimage = UIImage(named: "user_male")
                        
                        guard let imageData = tempimage!.jpegData(compressionQuality: 1) else { return }
                        
                        FirebaseStorageService.shared.storeUserImage(image: imageData) { [weak self] (result) in
                            switch result {
                            case .success(let url):
                                //self?.imageURL = url
                                print("store default user Image with \(url)")
                                //print(self?.imageURL)
                            case .failure(let error):
                                print("this is \(error.localizedDescription)")
                                //print(error)
                            }
                        }
                        
                        UserDefaults.standard.set(true, forKey: "signedIn")
                    }
                } else {
                    print("go login!!")
                    self.navigationController?.isNavigationBarHidden = true
                }
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        //  SVProgressHUD.showError(withStatus: error.localizedDescription)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
}

@available(iOS 13.0, *)
extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

@available(iOS 13.0, *)
extension LoginVC: ASAuthorizationControllerDelegate {

  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
        guard let nonce = currentNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
        }
        // Initialize a Firebase credential.
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
        // Sign in with Firebase.
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error)
            } else if let user = authResult?.user {
                print(user.uid)
                
                if UserDefaults.standard.bool(forKey: "loggedIn") == false || UserDefaults.standard.bool(forKey: "signedIn") == false {
                    print("not yet logined...")
                    self.navigationController?.isNavigationBarHidden = true
                    UserDefaults.standard.set(true, forKey: "loggedIn")
                    
                    //let i = (authResult?.user.email)!.firstIndex(of: "@")
                    
                    var temp = PromiseUser(userName: (authResult?.user.email)!, userFriends: [], userId: (authResult?.user.uid)!, userImage: (authResult?.user.uid)!, userCode: Int.random(in: 100000...999999), documentId: MyApi.shared.randomNonceString())
                    MyApi.shared.addUserData(temp)
                    
                    if UserDefaults.standard.bool(forKey: "signedIn") == false {
                        let tempimage = UIImage(named: "user_male")
                        
                        guard let imageData = tempimage!.jpegData(compressionQuality: 1) else {
                             return
                        }
                            FirebaseStorageService.shared.storeUserImage(image: imageData) { [weak self] (result) in
                                switch result {
                                case .success(let url):
                                    //self?.imageURL = url
                                    print("store default user Image + \(url)")
                                    //print(self?.imageURL)
                                case .failure(let error):
                                    print("this is error + \(error)")
                                    //print(error)
                                }
                            }
                        UserDefaults.standard.set(true, forKey: "signedIn")
                    }
                    
                } else {
                    print("go login!!")
                    self.navigationController?.isNavigationBarHidden = true
                }
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
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
