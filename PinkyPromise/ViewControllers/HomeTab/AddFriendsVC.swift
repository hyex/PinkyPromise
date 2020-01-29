//
//  AddFriendsVC.swift
//  PinkyPromise
//
//  Created by linc on 2020/01/29.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit
import BEMCheckBox

protocol ReceiveSelectedFriendsDelegate {
    func receiveSelectedIcon(data: [String])
}

protocol SendSelectedFriendsDelegate {
    func sendSelectedFriends(data: [Int])
}

class AddFriendsVC: UIViewController {

    @IBOutlet weak var backBtn: UIBarButtonItem!

    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    var checkBoxesState: [Int : Bool] = [:]
    
    var delegate: SendSelectedFriendsDelegate!
    
    var myFriends: [Int : [String]]!
    
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
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        let arr = checkBoxesState.filter({ (key: Int, value: Bool) -> Bool in
            return value ? true : false
            }).keys
        
        self.delegate.sendSelectedFriends(data: Array(arr))
        self.navigationController?.popViewController(animated: false)
    }
    
}


extension AddFriendsVC: UITableViewDelegate {}

extension AddFriendsVC: UITableViewDataSource {
    
    // MARK: - View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCheckCell") as! CheckFriendsTVC
        
        let friend = self.myFriends[indexPath.row]
        
        cell.friendProfileImg.layer.cornerRadius = cell.friendProfileImg.frame.width/2
        cell.friendProfileImg.clipsToBounds = true
        
        myFriends.forEach { (friend) in
            FirebaseStorageService.shared.getUserImageWithName(name: friend.value[1]) { (result) in
                switch result {
                case .failure(let err):
                    print(err)
                    break
                case .success(let userImage):
                    cell.friendProfileImg.image = userImage
                    break
                }
            }
        }
        
        cell.friendNameLabel.text = friend?[0]
        //        cell.promiseNameLabel.text = rowData.promisename
        cell.checkBox.delegate = self
        cell.checkBox.tag = indexPath.row
        
        if let isOn = checkBoxesState[indexPath.row] {
            cell.checkBox.on = isOn ? true: false
            checkBoxesState[cell.checkBox.tag] = cell.checkBox.on
        } else {
            cell.checkBox.on = false
            checkBoxesState[cell.checkBox.tag] = cell.checkBox.on
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    // MARK: - Logic
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CheckFriendsTVC
        
        cell.switchCheckBox()
        checkBoxesState.updateValue(cell.checkBox.on, forKey: cell.checkBox.tag)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

extension AddFriendsVC: BEMCheckBoxDelegate {
    func didTap(_ checkBox: BEMCheckBox) {
        checkBoxesState.updateValue(checkBox.on, forKey: checkBox.tag)
    }
}


