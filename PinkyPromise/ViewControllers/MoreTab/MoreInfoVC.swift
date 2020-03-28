//
//  MoreInfoVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 3/27/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

var checkDeleteAccount = false

class MoreInfoVC: UIViewController {
    
    @IBOutlet weak var accountDeleteBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    @IBAction func AccountDeleteBtnAction(_ sender: Any) {
        let alert =  UIAlertController(title: "회원 탈퇴", message: "모든 기록이 없어져요. 정말 회원 탈퇴를 하시나요?", preferredStyle: .actionSheet)
        let ok =  UIAlertAction(title: "확인", style: .default) { (action) in
            print("ok")
            // 탈퇴 API
            let tempUID = FirebaseUserService.currentUserID!
            
            //사진파일도 없애는 함수 만들어줘야한다. 아직 시간이 없어서 미완성
            MyApi.shared.deleteMeFromFriend(Uid: tempUID) { result3 in
                print("1")
                MyApi.shared.deleteUserWithUid(Uid: tempUID) { (result2) in
                    print("2")
                    MyApi.shared.deleteAboutMe { (result) in
                        print("3")
                        checkDeleteAccount = true
                        
                        UserDefaults.standard.set(false, forKey: "loggedIn")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let tempVC = storyboard.instantiateViewController(withIdentifier: "loginSB") as! UINavigationController
                        tempVC.modalPresentationStyle = .fullScreen
                        self.present(tempVC, animated: true, completion: nil)
                    }
                }
            }
            
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logoutBtnAction(_ sender: Any) {
        print("action")
        FirebaseUserService.signOut(success: {
            if UserDefaults.standard.bool(forKey: "loggedIn") == false {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tempVC = storyboard.instantiateViewController(withIdentifier: "loginSB") as! UINavigationController
                tempVC.modalPresentationStyle = .fullScreen
                self.present(tempVC, animated: true, completion: nil)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        print("this is logout Btn")
        print(FirebaseUserService.currentUserID ?? "nil")
        
    }
    
}

// MARK:- Initialization
extension MoreInfoVC {
    private func initView() {
        setNavigationBar()
        setBackBtn()
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
    
}
