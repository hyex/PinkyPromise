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
        MyApi.shared.getUsersFriendsData(completion: { result in
            self.friendList = result
        })
    }

}


extension MyFriendVC {
    private func initView() {
        setNavigationBar()
        setBackBtn()
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


extension MyFriendVC: UITableViewDelegate {
    
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
                friendCell.userName.text = rowData.userName! //rowData.userName!
                let imageName = rowData.userImage!
                
                FirebaseStorageService.shared.getUserImageWithName(name: imageName, completion: { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .failure(let err):
                            print(err)
                        case .success(let image):
                            friendCell.userImage.image = image
                        }
                    }
                })
         
                cell = friendCell
            }
        }
        
        return cell
    }
    
    
}
