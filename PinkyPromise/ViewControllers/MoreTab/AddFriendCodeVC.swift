//
//  AddFriendCodeVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/28/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

//refresh control

//Swift
//UIPasteboard.general.string = "ex)안녕하세요"
//출처: https://devsc.tistory.com/91?category=688748 [You Know Programing?]

import UIKit

class AddFriendCodeVC: UIViewController {

    @IBOutlet weak var myCodeLabel: UILabel!
    @IBOutlet weak var myCode: UILabel!
    @IBOutlet weak var friendCodeLabel: UILabel!
    @IBOutlet weak var friendCodeTextField: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var inputCodeView: UIView!
    
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

    @IBAction func confirmBtnAction(_ sender: Any) {
        // 텍스트필드 길이 검사 (6글자인지)
        let text = friendCodeTextField.text!
        print(text.count)
        // 서버로 보내서 이런 코드를 가진 유저가 있는지 검사
            // 있다면 추가해주고, 심플알람주고, pop
            // 없다면 없다는 실픔알림주고 끝
//        simpleAlert(title: "친구추가성공", message: "(변수)님과 친구성공")
    }
    
    
}

// MARK:- initialize
extension AddFriendCodeVC {
    private func initView() {
        setNavigationBar()
        setBackBtn()
        self.myCodeLabel.textColor = UIColor.appColor
        self.myCode.textColor = UIColor.appColor
        friendCodeTextField.delegate = self
        self.inputCodeView.backgroundColor = UIColor.appColor
        addSwipeGesture()
    }
    
    private func setNavigationBar() {
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear

//        self.navigationItem.setHidesBackButton(true, animated:false)
//
//        //your custom view for back image with custom size
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
//        let imageView = UIImageView(frame: CGRect(x: 2, y: 10, width: 30, height: 20))
//
//        let image = UIImage(systemName: "arrow.left")?.withTintColor(UIColor.appColor, renderingMode: .alwaysOriginal)
//        if let imgBackArrow = image {
//            imageView.image = imgBackArrow
//        }
//        view.addSubview(imageView)
//
//        let backTap = UITapGestureRecognizer(target: self, action: #selector(backToMain))
//        view.addGestureRecognizer(backTap)
//
//        let leftBarButtonItem = UIBarButtonItem(customView: view)
//        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }

    @objc func backToMain() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setBackBtn() {
        let image = UIImage(systemName: "arrow.left")?.withTintColor(UIColor.appColor, renderingMode: .alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = image
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        self.navigationController?.navigationBar.backItem?.title = ""
        
//        navigationItem.leftItemsSupplementBackButton = true
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//        self.navigationController?.navigationBar.backIndicatorImage = image
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
//        self.navigationController?.navigationBar.backItem?.leftBarButtonItem?.title = ""
//        self.navigationController?.navigationBar.backItem?.rightBarButtonItem?.title = ""
//        self.navigationController?.navigationBar.backItem
//        let backItem = UIBarButtonItem()
//        backItem.title = ""
//        backItem.image = image
//        self.navigationController?.navigationBar.backItem?.leftBarButtonItem = backItem

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
            let height = self.inputCodeView.frame.size.height
            self.view.frame.origin.y = -(self.inputCodeView.layer.position.y - height + CGFloat(49.0))
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
