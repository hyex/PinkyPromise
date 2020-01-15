//
//  FriendTabMainVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/13/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

struct FriendsInfo {
    var img : String
    var name : String
}

import UIKit

class FriendTabMainVC: UIViewController {
    
    @IBOutlet weak var friendMainTableView: UITableView!
    
    let friendsInPromise : [FriendsInfo] = [
    FriendsInfo(img: "seonyoung", name: "seonyoung"),
    FriendsInfo(img: "seonyoung", name: "heji" ),
    FriendsInfo(img: "seonyoung", name: "hyunjae"),
    FriendsInfo(img: "seonyoung", name: "uijeong")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.isHidden = true
        friendMainTableView.delegate = self
        friendMainTableView.dataSource = self
    }

}

extension FriendTabMainVC : UITableViewDelegate{ }

extension FriendTabMainVC : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return self.friendsInPromise.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as! FriendTableViewCell
        
        let rowData = self.friendsInPromise[indexPath.row]
        
    
        cell.friendProfileImg.image = UIImage(named: rowData.img)
        cell.friendNameLabel.text = rowData.name
        
        return cell
    }
}
