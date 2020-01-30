//
//  MyPageVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/30/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class MyPageVC: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    var user: PromiseUser? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        getUserData()
        initView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    private func getUserData() {
        
        var imageName: String = ""
        
        MyApi.shared.getUserData(completion: { result in
            DispatchQueue.main.async {
                self.user = result[0]
                imageName = self.user?.userImage ?? "defaultImage"
                FirebaseStorageService.shared.getUserImageWithName(name: imageName, completion: { result in
                    switch result {
                    case .failure(let err):
                        print(err)
                    case .success(let image):
                        self.userImage.image = image
                    }
                })
                self.userName.text = result[0].userName
            }
        })
    }
}

extension MyPageVC {
    private func initView() {
        setNavigationBar()
        setBackBtn()
//        self.userImage.makeCircle()
//        self.userImage = self.user?.userImage
        self.userName.text = self.user?.userName
        addSwipeGesture()
        
    }
    
    private func setNavigationBar() {
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
    }
    
    
    private func setBackBtn() {
        let image = UIImage(systemName: "arrow.left")?.withTintColor(UIColor.appColor, renderingMode: .alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = image
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
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
