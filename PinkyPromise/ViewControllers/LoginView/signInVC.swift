//
//  signInVC.swift
//  PinkyPromise
//
//  Created by apple on 2020/01/23.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class signInVC: UIViewController {

    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var PWTextFiled: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var resetPwBtn: UIButton!
    @IBOutlet weak var inputCodeView: UIView!
    
    override func viewDidLayoutSubviews() {
//        emailTextField.borderStyle = .none
//        let border = CALayer()
//        border.frame = CGRect(x: 0, y: emailTextField.frame.size.height-1, width: emailTextField.frame.width, height: 1)
//        border.backgroundColor = UIColor.white.cgColor
//        emailTextField.layer.addSublayer(border)
//        //emailTextField.textAlignment = .center
//        emailTextField.textColor = UIColor.white
//
//        PWTextFiled.borderStyle = .none
//        let border2 = CALayer()
//        border2.frame = CGRect(x: 0, y: PWTextFiled.frame.size.height-1, width: PWTextFiled.frame.width, height: 1)
//        border2.backgroundColor = UIColor.white.cgColor
//        PWTextFiled.layer.addSublayer(border2)
//        //emailTextField.textAlignment = .center
//        PWTextFiled.textColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBar()
        addSwipeGesture()
        textFieldUnderline(emailTextField)
        textFieldUnderline(PWTextFiled)
        
        registerForKeyboardNotifications()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.loginBtn.layer.cornerRadius = 10
        loginBtn.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        
        
        
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifications()
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
        
        alertController = UIAlertController(title: "이메일 주소를 입력하세요", message: "새 비밀번호를 위한 링크가 보내집니다.", preferredStyle: style)
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func addSwipeGesture() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .right) {
            self.navigationController?.popViewController(animated: false)
        }
    }

    func textFieldUnderline(_ textField:UITextField) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor(white: 1.0, alpha: 1.0).cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
        
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
    }

}

extension signInVC: UITextFieldDelegate {
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
        let height = self.inputCodeView.frame.size.height
        if let keyboardFrame: NSValue = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.view.frame.origin.y = -(self.inputCodeView.layer.position.y - keyboardHeight)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.emailTextField.resignFirstResponder()
        self.PWTextFiled.resignFirstResponder()
    }
    
    @objc func keyboardWillHide(_ note: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Called just before UITextField is edited
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        print("textFieldDidBeginEditing: \((textField.text) ?? "Empty")")
        
    }
    
    // Called immediately after UITextField is edited
    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("textFieldDidEndEditing: \((textField.text) ?? "Empty")")

    }
    
}


