//
//  AddFriendCodeVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/28/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

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
        self.navigationController?.navigationBar.isHidden = false
        initView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmBtnAction(_ sender: Any) {
        // 텍스트필드 길이 검사 (6글자인지)
        // 서버로 보내서 이런 코드를 가진 유저가 있는지 검사
            // 있다면 추가해주고, 심플알람주고, pop
            // 없다면 없다는 실픔알림주고 끝
        simpleAlert(title: "친구추가성공", message: "(변수)님과 친구성공")
    }
    
}

// MARK:- initialize
extension AddFriendCodeVC {
    private func initView() {
        setNavi()
        setBackBtn()
        self.myCodeLabel.textColor = UIColor.appColor
        self.myCode.textColor = UIColor.appColor
        friendCodeTextField.delegate = self
        self.inputCodeView.backgroundColor = UIColor.appColor
        addSwipeGesture()
    }
    
    private func setNavi() {
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
        
    }
    
    
    private func setBackBtn() {
        let image = UIImage(systemName: "arrow.left")?.withTintColor(UIColor.appColor, renderingMode: .alwaysOriginal)
        self.navigationController?.navigationBar.backIndicatorImage = image
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        self.navigationController?.navigationBar.backItem?.title = ""
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.friendCodeTextField.resignFirstResponder()
        //        self.searchTextField.becomeFirstResponder()
    }
    
    // Called when the line feed button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.friendCodeTextField.resignFirstResponder()
        //            self.dismiss(animated: true, completion: nil)
        return true
    }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning()
    }
    // Called just before UITextField is edited
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing: \((textField.text) ?? "Empty")")
        
    }
    // Called immediately after UITextField is edited
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing: \((textField.text) ?? "Empty")")
    }
    
}
