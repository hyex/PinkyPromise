//
//  promiseDatailVC.swift
//  PinkyPromise
//
//  Created by SEONYOUNG LEE on 2020/01/28.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

struct Friend{
    var profileImg : String
    var name : String
}

class PromiseDetailVC: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var promiseNameLabel: UILabel!

    @IBOutlet weak var promiseInfoTableView: UITableView!
    @IBOutlet weak var promiseFriendTableView: UITableView!
    
    let PromiseFriends : [Friend] = [
        Friend(profileImg: "seonyoung", name: "sunnyangee"),
        Friend(profileImg: "seonyoung", name: "sunnyangee"),
        Friend(profileImg: "seonyoung", name: "sunnyangee"),
        Friend(profileImg: "seonyoung", name: "sunnyangee"),
        Friend(profileImg: "seonyoung", name: "sunnyangee"),
    ]
    
    var detailPromiseInfo : Promise? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        promiseFriendTableView.delegate = self
        promiseFriendTableView.dataSource = self
        promiseFriendTableView.tableFooterView = UIView()
    }
}

extension PromiseDetailVC : UITableViewDelegate{ }
extension PromiseDetailVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.PromiseFriends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friendCell = tableView.dequeueReusableCell(withIdentifier: "PromiseFriendTVC", for: indexPath) as! PromiseFriendTVC
        
        let rowData = self.PromiseFriends[indexPath.row]
        
        friendCell.friendProfileImg.layer.cornerRadius = friendCell.friendProfileImg.frame.width/2
        friendCell.friendProfileImg.clipsToBounds = true
        friendCell.friendProfileImg.image = UIImage(named: rowData.profileImg)
        
        friendCell.friendNameLabel.text = rowData.name
        
        return friendCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
