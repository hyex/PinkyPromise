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
    
    var promiseDetail : PromiseTable? = nil {
        didSet{
            print("promiseDetail : ", promiseDetail!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        promiseNameLabel.text = promiseDetail?.promiseName
        promiseInfoTableView.delegate = self
        promiseInfoTableView.dataSource = self
        promiseInfoTableView.tableFooterView = UIView()
        
        promiseFriendTableView.delegate = self
        promiseFriendTableView.dataSource = self
        promiseFriendTableView.tableFooterView = UIView()
    }
    
    /*@IBAction func backBtnAction(_ sender : Any) {
        self.dismiss(animated: false, completion: nil)
    }**/
    @IBAction func backBtnAction(_ sender : Any) {
        self.dismiss(animated: false, completion: nil)
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
        
        /*private(set) var promiseName: String!
        private(set) var promiseStartTime: Date
        private(set) var promiseEndTime: Date
        private(set) var promiseColor: String!
        private(set) var promiseIcon: String!
        private(set) var promiseUsers: Array<String>
        private(set) var isPromiseAchievement: Bool!
        private(set) var promisePanalty: String!
        private(set) var promiseId: String!**/
        
        let date : Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        if let start = promiseDetail?.promiseStartTime {
            print(dateFormatter.string(from: start))
        }else{
            print("date to string fail")
        }
        
        if(tableView == promiseInfoTableView){
            switch (indexPath.row) {
            case 0:
                let startCell = tableView.dequeueReusableCell(withIdentifier: "StartDateVC") as! StartDateVC
                startCell.startDateLabel.text = "2020년 1월 30일 수요일 오전 9시"
//                startCell.startDateLabel.text = String(promiseDetail?.promiseStartTime)
                
                startCell.startDateImg.tintColor = UIColor.appColor
                startCell.editStartDateBtn.tintColor = UIColor.appColor
                
                return startCell
            case 1:
                let finalCell = tableView.dequeueReusableCell(withIdentifier: "FinalDateVC") as! FinalDateVC
                finalCell.finalDateLabel.text = "2020년 2월 20일 월요일 오후 11시"
                
                finalCell.finalDateImg.tintColor = UIColor.appColor
                finalCell.editFinalDateBtn.tintColor = UIColor.appColor
                
                return finalCell
            case 2:
                let colorCell = tableView.dequeueReusableCell(withIdentifier: "ColorVC") as! ColorVC
                
                colorCell.colorImg.tintColor = UIColor.appColor
                colorCell.editColorBtn.tintColor = UIColor.appColor
                
                return colorCell
            case 3:
                let iconCell = tableView.dequeueReusableCell(withIdentifier: "IconVC") as! IconVC
                
                iconCell.iconImg.tintColor = UIColor.appColor
                iconCell.editIconBtn.tintColor = UIColor.appColor
                
                return iconCell
            default:
                let alarmCell = tableView.dequeueReusableCell(withIdentifier: "AlarmVC") as! AlarmVC
                
                alarmCell.alarmImg.tintColor = UIColor.appColor
                
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
        if(tableView == promiseFriendTableView){
            return 60
        }
        return 50
    }
}

