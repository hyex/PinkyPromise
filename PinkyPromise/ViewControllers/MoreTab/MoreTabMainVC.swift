//
//  MoreTabMainVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/13/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//
import UIKit
import Photos

class MoreTabMainVC: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var imageChangeBtn: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var moreTableView: UITableView!
    
    let picker = UIImagePickerController()
    var user: PromiseUser? = nil
    
    var moreTableList:[MoreTableData] = [
        MoreTableData(title: "내 친구"),
        MoreTableData(title: "코드로 친구추가")
    ]
    
//    func onComplete(data: [MoreTableData]) -> Void {
//        DispatchQueue.main.async {
//            self.moreTableList = data
//            self.moreTableView.reloadData()
//        }
//    }
//     사용시
//    MyApi.shared.allMore(completion: self.onComplete(data:))

    override func viewDidLoad() {
        super.viewDidLoad()
        moreTableView.delegate = self
        moreTableView.dataSource = self
        self.navigationController?.navigationBar.isHidden = true
        picker.delegate = self
        getUserData()
        initView()
        
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined  {
            PHPhotoLibrary.requestAuthorization({status in
            })
        }
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
                imageName = self.user?.userImage ?? "defaultImage" // MARK: need to fix
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
extension MoreTabMainVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.row {
        case 0:
            let vc = storyboard?.instantiateViewController(identifier: "MyFriendVC") as! MyFriendVC
            self.navigationController?.pushViewController(vc, animated: false)
        case 1:
            let vc = storyboard?.instantiateViewController(identifier: "AddFriendCodeVC") as! AddFriendCodeVC
            self.navigationController?.pushViewController(vc, animated: false)
        default:
            print("MoreTab moving error")
        }
    }
}

extension MoreTabMainVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.moreTableList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        if let rankingcell = tableView.dequeueReusableCell(withIdentifier: "MoreTVC", for: indexPath) as? MoreTVC {

            let rowData = self.moreTableList[indexPath.row]
            rankingcell.title.text = rowData.title
            cell = rankingcell
        }
        
        return cell
    }

}

extension MoreTabMainVC {
    private func initView() {
        self.userImage.makeCircle()
        self.userImage.applyBorder(width: 2.0, color: UIColor.appColor)
        imageChangeBtn.backgroundColor = .white
        imageChangeBtn.applyRadius(radius: 8)
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
            //print(info)
            var name: String = ""
            
            if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
                let assetResources = PHAssetResource.assetResources(for: asset)
                let filename = assetResources.first!.originalFilename
                let nameArray = filename.components(separatedBy: ".")
                print(nameArray)
                name = nameArray[0]
            } else{
                let today = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyMMMddhhmmss"
                name = dateFormatter.string(from: today)
                print("userImage name error")
            }
            
            // image 형태 변환
            guard let imageData = image.jpegData(compressionQuality: 1) else {
                print("image convert error")
                return
            }
        
            // 여기서 뭐 엄청 뜸
            FirebaseStorageService.shared.storeUserImage(image: imageData, completion: { result in
                switch result {
                case .failure(let err):
                    print(err)
                case .success(let image):
                    print(image)
                }
                
            })
        }
        dismiss(animated: true, completion: nil)
    }


}
