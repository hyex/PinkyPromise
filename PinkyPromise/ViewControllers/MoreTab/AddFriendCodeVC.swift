//
//  AddFriendCodeVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/28/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//


import UIKit

class AddFriendCodeVC: UIViewController {

    @IBOutlet weak var myCodeLabel: UILabel!
    @IBOutlet weak var myCode: UILabel!
    @IBOutlet weak var myCodeCopyBtn: UIButton!
    @IBOutlet weak var friendCodeLabel: UILabel!
    @IBOutlet weak var friendCodeTextField: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var inputCodeView: UIView!
    
    var user: PromiseUser? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        self.navigationController?.navigationBar.isHidden = false
        initView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.popViewController(animated: true)
        unregisterForKeyboardNotifications()
    }
    
    @IBAction func myCodeCopyBtnAction(_ sender: Any) {
        UIPasteboard.general.string = self.myCode.text
    }
    

    @IBAction func confirmBtnAction(_ sender: Any) {
        
        let text = friendCodeTextField.text!
        
        if let textInt = Int(text) {
            AddFriendCodeService.shared.addFriendWithCode(code: textInt, completion: { result in
                if result == nil {
                    self.simpleAlert(title: "친구추가실패", message: "그런 코드를 가진 사용자가 없습니다.")
                } else {
                    let username = result?.userName
                    if (result?.userId == FirebaseUserService.currentUserID) {
                        self.simpleAlert(title: "친구추가실패", message: "이 코드는 본인 코드입니다!")
                    } else {
                        self.simpleAlert(title: "친구추가성공", message: "\(username!)님과 친구 성공! \n 이제 약속하러 가볼까요?")
                    }
                }
            })
        } else {
            self.simpleAlert(title: "친구추가실패", message: "코드는 숫자입니다.")
        }
    }
    
}

// MARK:- Initialization
extension AddFriendCodeVC {
    private func initView() {
        setNavigationBar()
        setBackBtn()
        setMyCode()
        self.myCodeCopyBtn.backgroundColor = UIColor.appColor
        self.myCodeCopyBtn.applyRadius(radius: 8.0)
        friendCodeTextField.delegate = self
        self.inputCodeView.backgroundColor = UIColor.appColor
        addSwipeGesture()
    }
    
    private func setNavigationBar() {
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
    }

    @objc func backToMain() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setBackBtn() {
        let image = UIImage(systemName: "arrow.left")?.withTintColor(UIColor.appColor, renderingMode: .alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = image
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        self.navigationController?.navigationBar.backItem?.title = ""
    }
    
    private func setMyCode() {
        self.myCodeLabel.textColor = UIColor.appColor
        self.myCode.textColor = UIColor.appColor
        
        AddFriendCodeService.shared.getUserData(completion: { result in
            DispatchQueue.main.async {
                self.myCode.text = String(result[0].userCode)
                self.user = result[0]
            }
        })
        
    }
    
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
   
    
}

extension AddFriendCodeVC: UITextFieldDelegate {
    
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
            self.view.frame.origin.y = -(self.inputCodeView.layer.position.y - keyboardHeight)
        }
        
    }
    
    @objc func keyboardWillHide(_ note: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.friendCodeTextField.resignFirstResponder()
    }
    
    // Called when the line feed button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.friendCodeTextField.resignFirstResponder()
        let text = friendCodeTextField.text!
        
        if let textInt = Int(text) {
            AddFriendCodeService.shared.addFriendWithCode(code: textInt, completion: { result in
                if result == nil {
                    self.simpleAlert(title: "친구추가실패", message: "그런 코드를 가진 사용자가 없습니다.")
                } else {
                    let username = result?.userName
                    if (result?.userId == FirebaseUserService.currentUserID) {
                        self.simpleAlert(title: "친구추가실패", message: "이 코드는 본인 코드입니다!")
                    } else {
                        self.simpleAlert(title: "친구추가성공", message: "\(username!)님과 친구 성공! \n 이제 약속하러 가볼까요?")
                    }
                }
            })
        } else {
            self.simpleAlert(title: "친구추가실패", message: "코드는 숫자입니다.")
        }
        
        return true
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
