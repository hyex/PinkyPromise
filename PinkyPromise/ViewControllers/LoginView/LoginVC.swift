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
import FBSDKCoreKit
import FBSDKLoginKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var faceSignInBtn: UIButton!
    @IBOutlet weak var googleSignInBtn: UIButton!
    @IBOutlet weak var appleSignInBtn: UIButton!
    @IBOutlet weak var pinkyTitle: UILabel!
    
    @IBOutlet weak var tempImage: UIImageView!
    
    var indicator: UIActivityIndicatorView?
    var currentNonce: String? = nil
    
    @IBAction func goToSignIn(){
        
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
        
        self.pinkyTitle.sizeToFit()
        self.view.backgroundColor = UIColor.appColor
        self.signInBtn.layer.cornerRadius = 10
        self.signUpBtn.layer.cornerRadius = 10
        self.faceSignInBtn.setTitle("페이스북으로 로그인!", for: .normal)
        self.faceSignInBtn.layer.cornerRadius = 10
        self.appleSignInBtn.layer.cornerRadius = 10
        self.googleSignInBtn.layer.cornerRadius = 10
        
        self.faceSignInBtn.addTarget(self, action: #selector(self.handleCustomFBLogin), for: .touchUpInside)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.pinkyTitle.center.x += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        //print(Auth.auth().currentUser?.email ?? "")
        
        //        var temp3 = [String]()
        //        var temp4 = [[PromiseTable]]()
        
        //        MyApi.shared.getPromiseDataSorted { (temp4) in
        //            for douc1 in temp4 {
        //                print("this is douc1...")
        //                for douc2 in douc1 {
        //                    print("this is douc2.. +\(douc2.promiseName) + \(douc2.promiseColor)" )
        //                }
        //            }
        //        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if UserDefaults.standard.bool(forKey: "loggedIn") == true {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
}

extension LoginVC: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Something is wrong with FB user: \(String(describing: error))")
            }
            print("successfully logged in with our user: \(String(describing: user))")
        })
        
        GraphRequest(graphPath: "/me", parameters: ["fields": "email, id, name"]).start { (connection, result, err) in
            
            if err != nil {
                print("failed to login: \(String(describing: err))")
                return
            }
            print(result ?? "")
        }
    }
    
    @objc func handleCustomFBLogin() {
        LoginManager().logIn(permissions: ["email", "public_profile"], from: self) { (result, err) in
            
            if err != nil {
                print("FB login failed: \(String(describing: err))")
                return
            }
            let accessToken = AccessToken.current
            guard let accessTokenString = accessToken?.tokenString else { return }
            
            let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
            Auth.auth().signIn(with: credentials) { (user, error) in
                if error != nil {
                    print("Something is wrong with FB user: \(String(describing: error))")
                    return
                }
                let userID = user?.user.uid
                let fullName = user?.user.displayName
                
                //signin을 만들어서 더 추가하면됨
                if UserDefaults.standard.bool(forKey: "loggedIn") == false || UserDefaults.standard.bool(forKey: "signedIn") == false {
                    print("not yet logined...")
                    self.navigationController?.isNavigationBarHidden = true
                    UserDefaults.standard.set(true, forKey: "loggedIn")
                    
                    MyApi.shared.getUserData(completion: { (result) in
                        if result.count == 0 {
                            let temp = PromiseUser(userName: fullName!, userFriends: [], userId: userID!, userImage: "userDefaultImage", userCode: Int.random(in: 100000...999999), documentId: MyApi.shared.randomNonceString())
                            MyApi.shared.addUserData(temp)
                            
                            if UserDefaults.standard.bool(forKey: "signedIn") == false{
                                let tempimage = UIImage(named: "userDefaultImage")
                                
                                guard let imageData = tempimage!.jpegData(compressionQuality: 0.1) else { return }
                                
                                FirebaseStorageService.shared.storeUserImage(imageName: "userDefaultImage",image: imageData) { [weak self] (result) in
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
                        }
                    })
                    
                } else {
                    print("go login!!")
                    self.navigationController?.isNavigationBarHidden = true
                }
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func showEmailAddress() {
        
        let accessToken = AccessToken.current
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signIn(with: credentials) { (user, error) in
            if error != nil {
                print("Something is wrong with FB user: \(String(describing: error))")
                return
            }
            let userID = user?.user.uid
            let fullName = user?.user.displayName
            //print(user?.user.email)
            
            //signin을 만들어서 더 추가하면됨
            if UserDefaults.standard.bool(forKey: "loggedIn") == false || UserDefaults.standard.bool(forKey: "signedIn") == false {
                print("not yet logined...")
                self.navigationController?.isNavigationBarHidden = true
                UserDefaults.standard.set(true, forKey: "loggedIn")
                
                let temp = PromiseUser(userName: fullName!, userFriends: [], userId: userID!, userImage: "userDefaultImage", userCode: Int.random(in: 100000...999999), documentId: MyApi.shared.randomNonceString())
                MyApi.shared.addUserData(temp)
                
                if UserDefaults.standard.bool(forKey: "signedIn") == false{
                    let tempimage = UIImage(named: "userDefaultImage")
                    
                    guard let imageData = tempimage!.jpegData(compressionQuality: 0.1) else { return }
                    
                    FirebaseStorageService.shared.storeUserImage(imageName: "userDefaultImage", image: imageData) { [weak self] (result) in
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
        
        //        GraphRequest(graphPath: "/me", parameters: ["fields": "email, id, name"]).start { (connection, result, err) in
        //            if err != nil {
        //                print("failed to login: \(err)")
        //                return
        //            }
        //            print(result ?? "")
        //        }
        
    }
}

extension LoginVC: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            //SVProgressHUD.showError(withStatus: error.localizedDescription)
            print(error.localizedDescription)
        } else {
            //SVProgressHUD.show()
            //self.indicator?.startAnimating()
            //            let fullName = user.profile.name
            //            let email = user.profile.email
            
            guard let idToken = user.authentication.idToken else { return }
            guard let accessToken = user.authentication.accessToken else { return }
            let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signIn(with: credentials) { (user, error) in
                if error != nil {
                    //SVProgressHUD.showError(withStatus: error?.localizedDescription)
                    print(error?.localizedDescription ?? "")
                }
                
                let userID = user?.user.uid
                let fullName = user?.user.displayName
                self.indicator?.stopAnimating()
                //SVProgressHUD.dismiss()
                //let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                //signin을 만들어서 더 추가하면됨
                if UserDefaults.standard.bool(forKey: "loggedIn") == false || UserDefaults.standard.bool(forKey: "signedIn") == false {
                    print("not yet logined...")
                    self.navigationController?.isNavigationBarHidden = true
                    UserDefaults.standard.set(true, forKey: "loggedIn")
                    
                    MyApi.shared.getUserData(completion: { (result) in
                        if result.count == 0 {
                            let temp = PromiseUser(userName: fullName!, userFriends: [], userId: userID!, userImage: "userDefaultImage", userCode: Int.random(in: 100000...999999), documentId: MyApi.shared.randomNonceString())
                            MyApi.shared.addUserData(temp)
                            
                            if UserDefaults.standard.bool(forKey: "signedIn") == false{
                                let tempimage = UIImage(named: "userDefaultImage")
                                
                                guard let imageData = tempimage!.jpegData(compressionQuality: 0.1) else { return }
                                
                                FirebaseStorageService.shared.storeUserImage(imageName: "userDefaultImage",image: imageData) { [weak self] (result) in
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
                        }
                    })
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
                        UserDefaults.standard.set(true, forKey: "appleLogin")
                        //let i = (authResult?.user.email)!.firstIndex(of: "@")
                        
                        MyApi.shared.getUserData(completion: { (result) in
                            if result.count == 0 {
                                let temp = PromiseUser(userName: (user.email)!, userFriends: [], userId: (authResult?.user.uid)!, userImage: "userDefaultImage", userCode: Int.random(in: 100000...999999), documentId: MyApi.shared.randomNonceString())
                                MyApi.shared.addUserData(temp)
                                
                                if UserDefaults.standard.bool(forKey: "signedIn") == false {
                                    let tempimage = UIImage(named: "userDefaultImage")
                                    
                                    guard let imageData = tempimage!.jpegData(compressionQuality: 0.1) else {
                                        return
                                    }
                                    FirebaseStorageService.shared.storeUserImage(imageName: "userDefaultImage",image: imageData) { [weak self] (result) in
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
                            }
                        })
                        
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
    
    func forgotPasswordLabelTapped(){
        //        let controller = ResetPWVC()
        //        self.navigationController?.pushViewController(controller, animated: true)
        self.showAlertPWResetController(style: UIAlertController.Style.alert)
    }
    
    func showAlertPWResetController(style: UIAlertController.Style) {
        let alertController: UIAlertController
        
        alertController = UIAlertController(title: "이름을 입력하세요", message: "새 비밀번호를 위한 링크가 보내집니다.", preferredStyle: style)
        
        let cancelActoin: UIAlertAction
        cancelActoin = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertController.addTextField { (field: UITextField ) in
            field.placeholder = "test@test.com"
            field.textContentType = UITextContentType.emailAddress
        }
        
        let okAction: UIAlertAction
        okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            FirebaseUserService.forgotPassword(withEmail: (alertController.textFields![0] as UITextField).text! , success: {
                //SVProgressHUD.showInfo(withStatus: "비밀번호 재설정 링크가 이메일 주소로 전송되었습니다.")
                self.showAlert(message: "비밀번호 재설정 링크가 이메일 주소로 전송되었습니다.")
                self.navigationController?.popViewController(animated: true)
                //SVProgressHUD.dismiss()
            }) { (error) in
                //SVProgressHUD.showError(withStatus: error.localizedDescription)
                self.showAlert(message: "\(error.localizedDescription)")
            }
        })
        
        alertController.addAction(okAction)
        alertController.addAction(cancelActoin)
        
        self.present(alertController, animated: true, completion: {
            print("alert controller shown")
        })
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.view.tintColor = UIColor.blueberry
        alert.setValue(NSAttributedString(string: alert.title!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.blueberry]), forKey: "attributedTitle")
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        action.setValue(UIColor.blueberry, forKey: "titleTextColor")
        alert.addAction(action)
        self.present(alert, animated: true)
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
