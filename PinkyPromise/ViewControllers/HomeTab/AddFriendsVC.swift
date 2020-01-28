//
//  AddFriendsVC.swift
//  PinkyPromise
//
//  Created by linc on 2020/01/29.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit
import BEMCheckBox

class AddFriendsVC: UIViewController {
    
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - 임시 친구약속 데이터
    
    let friendsInPromise : [FriendsInfo] = [
        FriendsInfo(img: "seonyoung", friendname: "sunnyangee", promisename: "매일 성북천 3K 조깅"),
        FriendsInfo(img: "heji", friendname: "hyex", promisename: "물 하루 1L 이상 마시기 "),
        FriendsInfo(img: "hyunjae", friendname: "hyunJae", promisename: "2시 전 취침 10시 전 기상"),
        FriendsInfo(img: "uijeong", friendname: "jeongUijeong", promisename: "One day One commit"),
        FriendsInfo(img: "seonyoung", friendname: "sunnyangee", promisename: "매일 성북천 3K 조깅"),
        FriendsInfo(img: "heji", friendname: "hyex", promisename: "물 하루 1L 이상 마시기 "),
        FriendsInfo(img: "hyunjae", friendname: "hyunJae", promisename: "2시 전 취침 10시 전 기상"),
        FriendsInfo(img: "uijeong", friendname: "jeongUijeong", promisename: "One day One commit")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    // MARK: - Navigation
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        
    }
    
    
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}


extension AddFriendsVC: UITableViewDelegate {}

extension AddFriendsVC: UITableViewDataSource {
    
    // MARK: - TableView View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendsInPromise.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCheckCell") as! CheckFriendsTVC
        
        let rowData = self.friendsInPromise[indexPath.row]
        
        cell.friendProfileImg.layer.cornerRadius = cell.friendProfileImg.frame.width/2
        cell.friendProfileImg.clipsToBounds = true
        
        cell.friendProfileImg.image = UIImage(named: rowData.img)
        cell.friendNameLabel.text = rowData.friendname
//        cell.promiseNameLabel.text = rowData.promisename
       return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    // Mark: -
}
