//
//  MyFriendVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/30/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class MyFriendVC: UIViewController {
    
    @IBOutlet weak var myFriendTableView: UITableView!
    
    var friendList: [PromiseUser]? {
        didSet { myFriendTableView.reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        getFriendData()
        setUpTableView()
        initView()
    }
    
    private func setUpTableView() {
        myFriendTableView.delegate = self
        myFriendTableView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func getFriendData() {
        MyFriendService.shared.getUsersFriendsData(completion: { result in
            DispatchQueue.main.async {
                self.friendList = result
            }
        })
    }

}

// MARK:- Initialization
extension MyFriendVC {
    private func initView() {
        setNavigationBar()
        addBackButton()
        addSwipeGesture()
    }
    
    private func setNavigationBar() {
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
        bar.topItem?.title = "내 친구"
        bar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: CGFloat(20.0))]
        
    }
    func addBackButton() {
        let backButton = UIButton(type: .custom)
        let image = UIImage(systemName: "arrow.left")?.withTintColor(UIColor.appColor, renderingMode: .alwaysOriginal)
        backButton.setImage(image, for: .normal)
        backButton.setImage(image, for: .selected)
        backButton.setTitle("", for: .normal)
//        backButton.setTitleColor(backButton.tintColor, for: .normal) // You can change the TitleColor
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    @objc func backAction(_ sender: UIButton) {
       let _ = self.navigationController?.popViewController(animated: true)
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

extension MyFriendVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension MyFriendVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let friendList = self.friendList else { return 0 }
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        if let friendCell = tableView.dequeueReusableCell(withIdentifier: "MyFriendTVC", for: indexPath) as? MyFriendTVC {
            
            if let friendList = self.friendList {
                let rowData = friendList[indexPath.row]
                friendCell.userName.text = rowData.userName!
                let imageName = rowData.userImage!
                if imageName == FirebaseUserService.currentUserID! {
                    FirebaseStorageService.shared.getUserImageWithName(name: imageName, completion: { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .failure(let err):
                                print(err)
                                friendCell.userImage.image = UIImage(named: "userDefaultImage")
                            case .success(let image):
                                friendCell.userImage.image = image
                            }
                        }
                    })
                }
         
                cell = friendCell
            }
        }
        
        return cell
    }
    
    
}
