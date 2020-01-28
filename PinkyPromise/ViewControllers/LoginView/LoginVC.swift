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

class LoginVC: UIViewController {
    
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var googleSignInBtn: UIButton!
    @IBOutlet weak var appleSignInBtn: UIButton!
    @IBOutlet weak var anomynousSignbtn: UIButton!
    @IBOutlet weak var pinkyTitle: UILabel!
    
    @IBOutlet weak var bottomView: UIImageView!
    @IBOutlet weak var tempImage: UIImageView!
    
    var indicator: UIActivityIndicatorView?
    
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
        
    }
    
    @IBAction func anomynousSignIn() {
//        Auth.auth().signInAnonymously { (authResult, error) in
//            if let error = error {
//                print(error.localizedDescription)
//            }
//            guard let user = authResult?.user else { return }
//            let isAnonymous = user.isAnonymous //true
//            let uid = user.uid
//            //self.performSegue(withIdentifier: "loginSegue", sender: nil)
//        }
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
        
        //        let tempProgress = ProgressTable(progressDay: Timestamp(seconds: 1577946254, nanoseconds: 157794620), progressDegree: 3, promiseId: "sdff9033", userId: "leehj test")
        //
        //        MyApi.shared.addProgressData(tempProgress)
        //
        //        MyApi.shared.getProgressData { (result) in
        //            for document in result {
        //                print(document.progressDay as Any)
        //                print(document.progressDegree as Any)
        //                print(document.userId as Any)
        //                print(document.promiseId as Any)
        //
        //                let days = NSDate(timeIntervalSince1970: TimeInterval(document.progressDay!.seconds))
        //                print("\(days)")
        //            }
        //        }
        
        MyApi.shared.deleteUserWithUid(Uid: "LbyESVddCnhGCTbRphoNU15fXok1")
        
        print(Auth.auth().currentUser?.email ?? "")
        
        //        let Promisedd = PromiseTable(promiseName: "sdfds", isPromiseAlarm: true, promiseStartTime: Date(), promiseEndTime: Date(), promiseColor: "red", promiseIcon: "smile", promiseAlarmTime: Date(), promiseUsers: [], isPromiseAchievement: false, promisePanalty: "qjfclrdms tlfh", promiseId: "Q1is3jCUDajGT6wJB9wZ")
        
        //MyApi.shared.addPromiseData(Promisedd)
        
        var temp = [Any]()
        
        //        MyApi.shared.getProgressData { (temp) in
        //            for douc in temp {
        //                print(douc.progressDay)
        //                print(douc.progressDegree)
        //                print(douc.promiseId)
        //                print(douc.userId)
        //            }
        //        }
        
        FirebaseStorageService.shared.getPromiseImageWithName(name: "IMG_0001.PNG") { (result) in
            switch result {
            case .failure(let error): print(error)
            case .success(let firebaseimage): self.tempImage.image = firebaseimage
            }
        }
        
        MyApi.shared.getPromiseDataSinceToday { (result) in
            for douc in result {
                print(douc.promiseName)
            }
        }
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
            
            Auth.auth().signInAndRetrieveData(with: credentials) { (user, error) in
                if error != nil {
                    //SVProgressHUD.showError(withStatus: error?.localizedDescription)
                    print(error?.localizedDescription ?? "")
                }
                
                let userID = user?.user.uid
                
                self.indicator?.stopAnimating()
                //SVProgressHUD.dismiss()
                UserDefaults.standard.set(true, forKey: "loggedIn")
                //let appDelegate = UIApplication.shared.delegate as! AppDelegate
             
                print(fullName)
                print(email)
                
                if UserDefaults.standard.bool(forKey: "loggedIn") == false {
                    print("not yet logined...")
                    self.navigationController?.isNavigationBarHidden = true
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                } else {
                    print("go login!!")
                    self.navigationController?.isNavigationBarHidden = true
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    //self.navigationController?.pushViewController(MainTabBarController(), animated: true)
                }
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
