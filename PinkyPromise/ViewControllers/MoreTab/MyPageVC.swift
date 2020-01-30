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
    @IBOutlet weak var imageChangeBtn: UIButton!
    @IBOutlet weak var userName: UILabel!
    
    let picker = UIImagePickerController()
    var user: PromiseUser? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        picker.delegate = self
        getUserData()
        initView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func imageChangeBtnAction(_ sender: Any) {
        
        let alert =  UIAlertController(title: "프로필 사진 변경", message: "어떤 사진으로 변경하시나요?", preferredStyle: .actionSheet)
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in
            self.openLibrary()
            
        }
        
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
            
            self.openCamera()
            
        }


        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    
    private func getUserData() {
        
        var imageName: String = ""
        
        MyApi.shared.getUserData(completion: { result in
            DispatchQueue.main.async {
                self.user = result[0]
                self.userName.text = result[0].userName
                imageName = self.user?.userImage ?? "defaultImage"
                FirebaseStorageService.shared.getUserImageWithName(name: imageName, completion: { result in
                    switch result {
                    case .failure(let err):
                        print(err)
                    case .success(let image):
                        self.userImage.image = image
                    }
                })
                
            }
        })
    }
}

extension MyPageVC {
    private func initView() {
        setNavigationBar()
        setBackBtn()
        self.userImage.makeCircle()
//        self.userImage = self.user?.userImage
//        self.userName.text = self.user?.userName
        imageChangeBtn.backgroundColor = .white
        imageChangeBtn.applyRadius(radius: 8)
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

extension MyPageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openLibrary(){
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
        
    }

    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        } else {
            print("Camera not available")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            self.userImage.image = image
            // MARK: need to add
            // image 넘기기 서버로
            print(info)
            
        }
        dismiss(animated: true, completion: nil)
    }


}
