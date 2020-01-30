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
    
    var promiseDetail : Promise? = nil {
        didSet{
            print(promiseDetail!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        promiseNameLabel.text = "10시 전에 일어나기"
        promiseInfoTableView.delegate = self
        promiseInfoTableView.dataSource = self
        promiseInfoTableView.tableFooterView = UIView()
        
        promiseFriendTableView.delegate = self
        promiseFriendTableView.dataSource = self
        promiseFriendTableView.tableFooterView = UIView()
    }
}

extension PromiseDetailVC : UITableViewDelegate{ }
extension PromiseDetailVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCnt : Int = 0
        
        if(tableView == promiseInfoTableView) {
            rowCnt = 5
        }else if(tableView == promiseFriendTableView){
            rowCnt = self.PromiseFriends.count
        }
        return rowCnt
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == promiseInfoTableView){
            switch (indexPath.row) {
            case 0:
                let startCell = tableView.dequeueReusableCell(withIdentifier: "StartDateVC") as! StartDateVC
                startCell.startDateLabel.text = "2020년 1월 30일 수요일 오전 9시"
                return startCell
            case 1:
                let finalCell = tableView.dequeueReusableCell(withIdentifier: "FinalDateVC") as! FinalDateVC
                finalCell.finalDateLabel.text = "2020년 2월 20일 월요일 오후 11시"
                return finalCell
            case 2:
                let colorCell = tableView.dequeueReusableCell(withIdentifier: "ColorVC") as! ColorVC
                return colorCell
            case 3:
                let iconCell = tableView.dequeueReusableCell(withIdentifier: "IconVC") as! IconVC
                return iconCell
            default:
                let alarmCell = tableView.dequeueReusableCell(withIdentifier: "AlarmVC") as! AlarmVC
                return alarmCell
                
            }
        }else {
            let friendCell = tableView.dequeueReusableCell(withIdentifier: "PromiseFriendTVC", for: indexPath) as! PromiseFriendTVC
            
            let rowData = self.PromiseFriends[indexPath.row]
            
            friendCell.friendProfileImg.layer.cornerRadius = friendCell.friendProfileImg.frame.width/2
            friendCell.friendProfileImg.clipsToBounds = true
            friendCell.friendProfileImg.image = UIImage(named: rowData.profileImg)
            
            friendCell.friendNameLabel.text = rowData.name
            
            return friendCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

