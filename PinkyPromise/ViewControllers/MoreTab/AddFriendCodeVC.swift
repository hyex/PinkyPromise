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

        // MARK: - need to add
        // 서버로 보내서 이런 코드를 가진 유저가 있는지 검사
        
        let result: PromiseUser? = PromiseUser(userName: "김혜지", userFriends:[], userId: "1", userImage: "1", userCode: 1, documentId: "0")
        if result == nil {
            simpleAlert(title: "친구추가실패", message: "그런 코드를 가진 사용자가 없습니다.")
        } else {
            let username = result?.userName
            simpleAlert(title: "친구추가성공", message: "\(username!)님과 친구성공")
        }
            
    }
    
    
}

// MARK:- initialize
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
    
    private func setMyCode() {
        self.myCodeLabel.textColor = UIColor.appColor
        self.myCode.textColor = UIColor.appColor
        
        MyApi.shared.getUserData(completion: { result in
            DispatchQueue.main.async {
                self.myCode.text = String(result[0].userCode)
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
         let text = friendCodeTextField.text!
        
        // MARK: - need to add
        // 서버로 보내서 이런 코드를 가진 유저가 있는지 검사
        
        let result: PromiseUser? = PromiseUser(userName: "김혜지", userFriends:[], userId: "1", userImage: "1", userCode: 1, documentId: "0")
        if result == nil {
            simpleAlert(title: "친구추가실패", message: "그런 코드를 가진 사용자가 없습니다.")
        } else {
            let username = result?.userName
            simpleAlert(title: "친구추가성공", message: "\(username!)님과 친구성공")
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
