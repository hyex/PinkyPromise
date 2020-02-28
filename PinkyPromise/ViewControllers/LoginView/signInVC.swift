//
//  signInVC.swift
//  PinkyPromise
//
//  Created by apple on 2020/01/23.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class signInVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var PWTextFiled: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var resetPwBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loginBtn.layer.cornerRadius = 10
        loginBtn.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    }
    
    @objc func signIn(){
        if (emailTextField.text!.isEmpty || PWTextFiled.text!.isEmpty){
            self.showAlert(message: "모든 필드는 필수입니다.")
        }
        else {
            FirebaseUserService.signIn_(withEmail: emailTextField.text!, password: PWTextFiled.text!, success: {
                UserDefaults.standard.set(true, forKey: "loggedIn")
//                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                //have to move maintapbar. dismiss해야한다.
                //여기서 어떻게 다음 화면으로 이동하는가?
                
                self.navigationController?.popViewController(animated: true)
            
            }) { (error) in
                //SVProgressHUD.showError(withStatus: error.localizedDescription)
                self.showAlert(message: "이메일 혹은 비밀번호를 다시한번 확인해 주세요!")
                print(error.localizedDescription)
            }
        }
    }

    @IBAction func forgotPasswordLabelTapped(){
//        let controller = ResetPWVC()
//        self.navigationController?.pushViewController(controller, animated: true)
        self.showAlertPWResetController(style: UIAlertController.Style.alert)
    }
    
    func showAlertPWResetController(style: UIAlertController.Style) {
        let alertController: UIAlertController
        
        alertController = UIAlertController(title: "새 비밀번호를 입력하세요", message: "비밀번호는 최소 6글자 이상입니다.", preferredStyle: style)
        
        let okAction: UIAlertAction
        okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            FirebaseUserService.forgotPassword(withEmail: self.emailTextField.text!, success: {
                //SVProgressHUD.showInfo(withStatus: "비밀번호 재설정 링크가 이메일 주소로 전송되었습니다.")
                self.showAlert(message: "비밀번호 재설정 링크가 이메일 주소로 전송되었습니다.")
                self.navigationController?.popViewController(animated: true)
                //SVProgressHUD.dismiss()
            }) { (error) in
                //SVProgressHUD.showError(withStatus: error.localizedDescription)
                self.showAlert(message: "\(error.localizedDescription)")
            }
        })
        
        let cancelActoin: UIAlertAction
        cancelActoin = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelActoin)
        
        alertController.addTextField { (field: UITextField ) in
            field.placeholder = "새 비밀번호를 입력하세요."
            field.textContentType = UITextContentType.newPassword
        }
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
