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
    @IBOutlet weak var cancleBtn: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var backBtn: UIBarButtonItem!
    var checkImage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.setNavigationBar()
        self.setBackBtn()
        
        self.profileImage.layer.cornerRadius = 20
        self.profileImage.clipsToBounds = true
        self.startBtn.layer.cornerRadius = 10
        self.backBtn.title = ""
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectImageView))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
    }
    
    private func setNavigationBar() {
        let bar:UINavigationBar! = self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        
        bar.backgroundColor = UIColor.clear
    }

    @objc func backToMain() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setBackBtn() {
        let image = UIImage(systemName: "arrow.left")?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = image
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        self.navigationController?.navigationBar.backItem?.title = ""
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        
        if self.passwordBtn.text == "" || self.emailBtn.text == "" || self.nickNameBtn.text == "" {
            self.showAlert(message: "모든 필드는 모두 작성해주세요!")
        } else {
            FirebaseUserService.signUp(withEmail: emailBtn.text!, password: passwordBtn.text!, username: nickNameBtn.text!, image: self.profileImage.image, defaultCheck: checkImage, success: {
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
                
                var imageName = ""
                if self.checkImage == true {
                    imageName = FirebaseUserService.currentUserID!
                } else {
                    imageName = "userDefaultImage"
                }
                
                let tempUser = PromiseUser(userName: self.nickNameBtn.text!, userFriends: [], userId: FirebaseUserService.currentUserID!, userImage: imageName, userCode: Int.random(in: 100000...999999), documentId:  MyApi.shared.randomNonceString())
                
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
    // 옵저버 등록
    func registerForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }

    // 옵저버 등록 해제
    func unregisterForKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ note: NSNotification) {
        //let height = self.inputCodeView.frame.size.height
        if let keyboardFrame: NSValue = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            //self.view.frame.origin.y = -(self.view.layer.position.y - keyboardHeight)
            self.view.frame.origin.y = -self.view.layer.position.y + keyboardHeight
        }
    }
    
    @objc func keyboardWillHide(_ note: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.passwordBtn.resignFirstResponder()
        self.emailBtn.resignFirstResponder()
        self.nickNameBtn.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

extension signUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        //dismiss(animated: true, completion: nil)
        profileImage.image = selectedImage
        self.checkImage = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
