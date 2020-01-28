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

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var inputCodeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSwipeGesture()
        initView()
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func addSwipeGesture() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
           if (sender.direction == .right) {
               print(sender.direction)
               print("swipe")
               self.dismiss(animated: false, completion: nil)}
       }

}

// MARK:- init
extension AddFriendCodeVC {
    private func initView() {
        self.backBtn.tintColor = .black
        self.inputCodeView.backgroundColor = UIColor.appColor
//        addSwipeGesture()
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
