//
//  FriendTabDetailVC.swift
//  PinkyPromise
//
//  Created by SEONYOUNG LEE on 2020/01/21.
//  Copyright © 2020 hyejikim. All rights reserved.
//

struct FriendDatailInfo{
    var image : String
    var name : String
    var successCnt : String
    var failCnt : String
    var longestCnt : String
}

import UIKit

class FriendTabDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var promiseTitleLabel: UILabel!
    @IBOutlet weak var friendDatailTableView: UITableView!
    
    let datailPromiseInfo : [FriendDatailInfo] = [
    FriendDatailInfo(image: "heji", name: "hyex", successCnt: "10", failCnt: "5", longestCnt: "7"),
    FriendDatailInfo(image: "heji", name: "hyex", successCnt: "10", failCnt: "5", longestCnt: "7"),
    FriendDatailInfo(image: "heji", name: "hyex", successCnt: "10", failCnt: "5", longestCnt: "7"),
    FriendDatailInfo(image: "heji", name: "hyex", successCnt: "10", failCnt: "5", longestCnt: "7"),
    FriendDatailInfo(image: "heji", name: "hyex", successCnt: "10", failCnt: "5", longestCnt: "7")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendDatailTableView.delegate = self
        friendDatailTableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datailPromiseInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendDetailTableViewCell", for: indexPath) as! FriendDetailTableViewCell
        
        let rowData = self.datailPromiseInfo[indexPath.row]
        
        cell.friendProfileImg.layer.cornerRadius = cell.friendProfileImg.frame.width/2
        cell.friendProfileImg.clipsToBounds = true
        cell.friendProfileImg.image = UIImage(named: rowData.image)
        
        cell.friendNameLabel.text = rowData.name
        cell.successCntLabel.text = rowData.successCnt
        cell.failCntLabel.text = rowData.failCnt
        cell.longestCntLabel.text = rowData.longestCnt
        
        return cell
    }
    
    @IBAction func backBtnAction(_ sender : Any){
        self.dismiss(animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
}

