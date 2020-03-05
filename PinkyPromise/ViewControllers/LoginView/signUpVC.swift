//
//  signUpVC.swift
//  PinkyPromise
//
//  Created by apple on 2020/01/23.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit
import Firebase
import Photos

class signUpVC: UIViewController {
    
    @IBOutlet weak var emailBtn: UITextField!
    @IBOutlet weak var passwordBtn: UITextField!
    @IBOutlet weak var nickNameBtn: UITextField!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileImage.layer.cornerRadius = 20
        self.profileImage.clipsToBounds = true
        self.startBtn.layer.cornerRadius = 10
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectImageView))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        
        if self.passwordBtn.text == "" || self.emailBtn.text == "" || self.nickNameBtn.text == "" {
            self.showAlert(message: "모든 필드는 모두 작성해주세요!")
        } else {
            FirebaseUserService.signUp(withEmail: emailBtn.text!, password: passwordBtn.text!, username: nickNameBtn.text!, image: self.profileImage.image, success: {
                FirebaseUserService.sendEmailVerification(failure: { (error) in
                    //SVProgressHUD.showError(withStatus: error.localizedDescription)
                    self.showAlert(message: "\(error.localizedDescription)")
                    //print(error.localizedDescription)
                    return
                })
                UserDefaults.standard.set(true, forKey: "loggedIn")
                
//                let tempDouble: CGFloat
//
//                if self.profileImage.image == UIImage(named: "userDefaultImage") {
//                    tempDouble = 1.0
//                } else {
//                    tempDouble = 0.1
//                }
//
//                guard let imageData = self.profileImage.image?.jpegData(compressionQuality: tempDouble) else {
//                    print("image convert error")
//                    return
//                }
//
//                FirebaseStorageService.shared.storeUserImage(image: imageData) { [weak self] (result) in
//                    switch result {
//                    case .success(let url):
//                        print("check 3")
//                    case .failure(let error):
//                        print("this is error")
//                        print(error)
//                    }
//                }
                
                let tempUser = PromiseUser(userName: self.nickNameBtn.text!, userFriends: [], userId: FirebaseUserService.currentUserID!, userImage: FirebaseUserService.currentUserID!, userCode: Int.random(in: 100000...999999), documentId:  MyApi.shared.randomNonceString())
                
                MyApi.shared.addUserData(tempUser)
                
                //self.showToast(message: "회원가입에 성공했습니다!")
                self.navigationController?.popViewController(animated: true)
                
                //                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                //                appDelegate.window?.rootViewController = MainTabBarController()
                //                self.dismiss(animated: true, completion: nil)
                
            }) { (error) in
                print("this is error")
                print(error.localizedDescription)
                self.showAlert(message: "\(error.localizedDescription)")
                print("this is error22")
            }
        }
        
    }
    
    @objc func handleSelectImageView() {
        
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization { (status: PHAuthorizationStatus) in
                print("Requesting authorization.")
            }
        }
        else {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.allowsEditing = true
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true)
        }
        
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        alert.setValue(NSAttributedString(string: alert.title!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedTitle")
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        action.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    func showToast(message : String) {
        let width_variable:CGFloat = 10
        let toastLabel = UILabel(frame: CGRect(x: width_variable, y: self.view.frame.size.height-100, width: view.frame.size.width-2*width_variable, height: 35))
        // 뷰가 위치할 위치를 지정해준다. 여기서는 아래로부터 100만큼 떨어져있고, 너비는 양쪽에 10만큼 여백을 가지며, 높이는 35로
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

extension signUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

extension signUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard var selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        //dismiss(animated: true, completion: nil)
        profileImage.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
