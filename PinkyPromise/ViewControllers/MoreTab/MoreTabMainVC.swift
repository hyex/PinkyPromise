//
//  MoreTabMainVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/13/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//
import UIKit

class MoreTabMainVC: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var imageChangeBtn: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var myFriendBtn: UIButton!
    @IBOutlet weak var addFriendCodeBtn: UIButton!
    @IBOutlet weak var logOutBtn: UIButton!
    
    let picker = UIImagePickerController()
    var user: PromiseUser? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        picker.delegate = self
        
        getUserData()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
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
                imageName = self.user?.userImage ?? (self.user?.userId)!
                FirebaseStorageService.shared.getUserImageWithName(name: imageName, completion: { result in
                    switch result {
                    case .failure(let err):
                        print(err)
                        self.userImage.image = UIImage(named: "user_male")
                    case .success(let image):
                        self.userImage.image = image
                    }
                })
            }
        })
    }
    
    @IBAction func myfriendBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "MyFriendVC") as! MyFriendVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func addFriendCodeBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "AddFriendCodeVC") as! AddFriendCodeVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func logOutBtnAction(_ sender: Any) {
//        FirebaseUserService.signOut(success: {
//            print("success")
//            // 로그인 페이지로 다시 가야할 듯 싶은디
//        }) { (err) in
//            print(err)
//        }
        
        FirebaseUserService.signOut(success: {
            
            if UserDefaults.standard.bool(forKey: "loggedIn") == false {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tempVC = storyboard.instantiateViewController(withIdentifier: "loginSB") as! UINavigationController
                tempVC.modalPresentationStyle = .fullScreen
                self.present(tempVC, animated: true, completion: nil)
                
                print("finished")
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
}


extension MoreTabMainVC {
    private func initView() {
        self.userImage.makeCircle()
        self.userImage.applyBorder(width: 2.0, color: UIColor.appColor)
        setUpBtn()
        
    }
    
    private func setUpBtn() {
        
        imageChangeBtn.backgroundColor = .white
        imageChangeBtn.applyRadius(radius: 8)
        
        let color = UIColor.appColor.withAlphaComponent(0.5)
        
        myFriendBtn.applyRadius(radius: 8)
        addFriendCodeBtn.applyRadius(radius: 8)
        logOutBtn.applyRadius(radius: 8)
        
        myFriendBtn.backgroundColor = color
        addFriendCodeBtn.backgroundColor = color
        logOutBtn.backgroundColor = color
    }
}

extension MoreTabMainVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            
            // type convert to jpeg
            guard let imageData = image.jpegData(compressionQuality: 1) else {
                print("image convert error")
                return
            }

            FirebaseStorageService.shared.storeUserImage(image: imageData, completion: { result in
                switch result {
                case .failure(let err):
                    print(err)
                case .success:
                    break
                }
            })
        }
        dismiss(animated: true, completion: nil)
    }


}
