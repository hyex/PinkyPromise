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
    
    var myFriendsImg: [UIImage]!

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
    
        DispatchQueue.global().sync {
            FirebaseStorageService.shared.getUserImageWithName(name: (friend?[1])!) { (result) in
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


