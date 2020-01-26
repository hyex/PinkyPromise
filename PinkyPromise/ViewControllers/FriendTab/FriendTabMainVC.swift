//
//  FriendTabMainVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/13/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

struct FriendsInfo {
    var img : String
    var friendname : String
    var promisename : String
}

import UIKit

class FriendTabMainVC: UIViewController {
    
    @IBOutlet weak var addNewPromiseBtn: UIButton!
    @IBOutlet weak var promiseCtnLabel: UILabel!
    @IBOutlet weak var friendMainTableView: UITableView!
    
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
//        self.navigationController?.navigationBar.isHidden = true
        friendMainTableView.delegate = self
        friendMainTableView.dataSource = self
        
        let purplePlus : UIImage = UIImage(named: "plus")!
        addNewPromiseBtn.setImage(purplePlus, for: UIControl.State.normal)
        
    }
    
    @IBAction func showPromiseDetail(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailNavigationController") as! DetailNavigationController

        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .overCurrentContext

        self.present(vc, animated: false)
    }
    
    @IBAction func addPromiseBtnAction(_ sender: Any) {
        print("in addPromiseBtnAction")
        
        let homeTabStoryboard = UIStoryboard(name: "HomeTab", bundle: nil)
        let vc = homeTabStoryboard.instantiateViewController(withIdentifier: "HomeNavigationController") as! HomeNavigationController
        
        print("after let vc")
        
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .overCurrentContext
        
        self.present(vc, animated: false, completion: nil)
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
        
        cell.friendProfileImg.layer.cornerRadius = cell.friendProfileImg.frame.width/2
        cell.friendProfileImg.clipsToBounds = true
        
        cell.friendProfileImg.image = UIImage(named: rowData.img)
        cell.friendNameLabel.text = rowData.friendname
        cell.promiseNameLabel.text = rowData.promisename
        
        let purpleArrow : UIImage = UIImage(named: "next")!
        cell.friendDatailBtn.setImage(purpleArrow, for: UIControl.State.normal)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
