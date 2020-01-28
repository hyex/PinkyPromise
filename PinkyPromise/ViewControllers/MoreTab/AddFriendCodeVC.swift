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
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
//        addSwipeGesture()
        initView()
        
    }
    
    
    func addSwipeGesture() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        print(sender)
           if (sender.direction == .right) {
               print(sender.direction)
               print("swipe")
               self.dismiss(animated: false, completion: nil)}
       }

}

// MARK:- init
extension AddFriendCodeVC {
    private func initView() {
//        self.backBtn.tintColor = .black
        setBackBtn()
        self.myCodeLabel.textColor = UIColor.appColor
        self.myCode.textColor = UIColor.appColor
        friendCodeTextField.delegate = self
        self.inputCodeView.backgroundColor = UIColor.appColor
//        addSwipeGesture()
    }
    
    @objc func backBtnAction(_ sender: UIBarButtonItem) {
           self.navigationController?.popViewController(animated: false)
       }
    
    private func setNavi() {
        self.navigationController?.isNavigationBarHidden = false
        // navi background color
        navigationController?.navigationBar.barTintColor =
            UIColor(displayP3Red: 247.0/255.0, green:  248.0/255.0, blue: 250.0/255.0, alpha: 1.0)

    }
    private func setBackBtn() {
        var backBtn: UIBarButtonItem!
        backBtn = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backBtnAction(_:))) 
        backBtn.tintColor = UIColor.appColor
        self.navigationController?.navigationItem.leftBarButtonItem  = backBtn
        
    }
    
    
    
//
//    func addSwipeGesture() {
//        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
//        rightSwipe.direction = .right
//        self.view.addGestureRecognizer(rightSwipe)
//    }
    
//    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
//        if (sender.direction == .right) {
//            print(sender.direction)
//            print("swipe")
//            self.dismiss(animated: false, completion: nil)}
//    }
    

    
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
        // Dispose of any resources that can be recreated.
        
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
