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
    @IBOutlet weak var addFriendKakaoBtn: UIButton!
    @IBOutlet weak var logOutBtn: UIButton!
    
    let picker = UIImagePickerController()
    var user: PromiseUser? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        picker.delegate = self
        // getUserData()
        initView()
        
    }
    
    func showAlertPWResetController(style: UIAlertController.Style) {
        let alertController: UIAlertController
        
        alertController = UIAlertController(title: "나의 이름을 입력하세요", message: "아무것도 없으면 이메일이 내 이름이 됩니다.", preferredStyle: style)
        
        let cancelActoin: UIAlertAction
        cancelActoin = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertController.addTextField { (field: UITextField ) in
            field.placeholder = "NickName"
            field.textContentType = UITextContentType.name
        }
        
        let okAction: UIAlertAction
        okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            
//            FirebaseUserService.forgotPassword(withEmail: (alertController.textFields![0] as UITextField).text! , success: {
//                //SVProgressHUD.showInfo(withStatus: "비밀번호 재설정 링크가 이메일 주소로 전송되었습니다.")
//                self.showAlert(message: "비밀번호 재설정 링크가 이메일 주소로 전송되었습니다.")
//                self.navigationController?.popViewController(animated: true)
//                //SVProgressHUD.dismiss()
//            }) { (error) in
//                //SVProgressHUD.showError(withStatus: error.localizedDescription)
//                self.showAlert(message: "\(error.localizedDescription)")
//            }
            MyApi.shared.updateUserNameinAppleLogin(name: (alertController.textFields![0] as UITextField).text ?? self.userName.text!)
        })
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: {
            print("alert controller shown")
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.dismiss(animated: false, completion: nil)
        
        if UserDefaults.standard.bool(forKey: "appleLogin") == true {
            self.showAlertPWResetController(style: UIAlertController.Style.alert)
            UserDefaults.standard.set(false, forKey: "appleLogin")
            self.userName.reloadInputViews()
        }
    }
    
    // MARK: wantToFix
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        getUserData()
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
        
        MoreTabMainService.shared.getUserData(completion: { result in
            DispatchQueue.main.async {
                       self.user = result[0]
                self.userName.text = result[0].userName
                imageName = (self.user?.userImage)!
                if imageName == self.user?.userId {
                    FirebaseStorageService.shared.getUserImageURLWithName(name: imageName, completion: { result in
                        switch result {
                        case .failure(let err):
                            print(err)
                        case .success(let url):
                            let imageUrl = URL(string: url)
                            do {
                                let data = try Data(contentsOf: imageUrl!)
                                self.userImage.image = UIImage(data: data)
                            } catch {
                                print("get image url failed")
                                //self.userImage.image = UIImage(named: "userDefaultImage")
                            }
                        }
                    })
                } else {
                    self.userImage.image = UIImage(named: "userDefaultImage")
                }
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
    
    
    @IBAction func addFriendKakaoBtnAction(_ sender: Any) {
        
        let template = KMTTextTemplate { (textTemplateBuilder) in
            let param = "param1=" + FirebaseUserService.currentUserID!
            textTemplateBuilder.text = "나랑 친구하자"
            textTemplateBuilder.addButton(KMTButtonObject(builderBlock: { (buttonBuilder) in
                buttonBuilder.title = "친구하러 가기"
                buttonBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.iosExecutionParams = param
                })
            }))
            textTemplateBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                linkBuilder.iosExecutionParams = param
            })
            
        }
        
        // 카카오링크 실행
        KLKTalkLinkCenter.shared().sendDefault(with: template, success: { (warningMsg, argumentMsg) in
            // 성공
            print("warning message: \(String(describing: warningMsg))")
            print("argument message: \(String(describing: argumentMsg))")

        }, failure: { (error) in
            // 실패
            print("error \(error)")
            
        })
        
    }
    
    @IBAction func logOutBtnAction(_ sender: Any) {
        
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
        addFriendKakaoBtn.applyRadius(radius: 8)
        logOutBtn.applyRadius(radius: 8)
        
        myFriendBtn.backgroundColor = color
        addFriendCodeBtn.backgroundColor = color
        addFriendKakaoBtn.backgroundColor = color
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
            guard let imageData = image.jpegData(compressionQuality: 0.1) else {
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
