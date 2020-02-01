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
    var perfect : String
    var threeQuarter : String
    var half : String
    var quarter : String
    var zero : String
}

import UIKit

class FriendTabDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var promiseTitleLabel: UILabel!
    @IBOutlet weak var friendDatailTableView: UITableView!
    
    let datailPromiseInfo : [FriendDatailInfo] = [
    FriendDatailInfo(image: "heji", name: "hyex", perfect: "10", threeQuarter: "7", half: "12", quarter: "3", zero: "2"),
    FriendDatailInfo(image: "heji", name: "hyex", perfect: "10", threeQuarter: "7", half: "12", quarter: "3", zero: "2"),
    FriendDatailInfo(image: "heji", name: "hyex", perfect: "10", threeQuarter: "7", half: "12", quarter: "3", zero: "2"),
    FriendDatailInfo(image: "heji", name: "hyex", perfect: "10", threeQuarter: "7", half: "12", quarter: "3", zero: "2"),
    FriendDatailInfo(image: "heji", name: "hyex", perfect: "10", threeQuarter: "7", half: "12", quarter: "3", zero: "2"),
    ]
    
    var detailPromise : PromiseWithFriend? = nil {
        didSet {
            print(self.detailPromise!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackBtn()
        getDetailPromiseData()
        
        friendDatailTableView.delegate = self
        friendDatailTableView.dataSource = self
        friendDatailTableView.tableFooterView = UIView()
    }
    
    private func getDetailPromiseData(){
        print("in getDatailPromiseData")
        
//        guard let promiseId = self.detailPromise?.promiseId , where promiseId != nil else {
//            MyApi.shared.getDataforDetailViewjr1(promiseID: promiseId) { (result) in
//                for douc in result.friendsDetail {
//                    print("--------douc--------")
//                    print(douc.friendName!)
//                    print(douc.friendDegree!)
//                    print(douc.friendImage!)
//                }
//
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datailPromiseInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendDetailTableViewCell", for: indexPath) as! FriendDetailTableViewCell
        
        let rowData = self.datailPromiseInfo[indexPath.row]
        
        cell.crownImg.image = UIImage(named: "crown")
        if(!(indexPath.row == 0)) {
            cell.crownImg.isHidden = true
        }
        
        cell.friendProfileImg.layer.cornerRadius = cell.friendProfileImg.frame.width/2
        cell.friendProfileImg.clipsToBounds = true
        cell.friendProfileImg.image = UIImage(named: rowData.image)
        
        cell.friendNameLabel.text = rowData.name
        cell.perfectCnt.text = rowData.perfect
        cell.threeQuarterCnt.text = rowData.threeQuarter
        cell.halfCnt.text = rowData.half
        cell.quarterCnt.text = rowData.quarter
        cell.zeroCnt.text = rowData.zero
        
        var nowProgressed : Double
        let p1 = 1.0 * Double(rowData.perfect)!
        let p2 = 0.75 * Double(rowData.threeQuarter)!
        let p3 = 0.5 * Double(rowData.half)!
        let p4 = 0.25 * Double(rowData.quarter)!
        
        nowProgressed = (p1 + p2 + p3 + p4) / 30.0
        cell.progressView.tintColor = UIColor.appColor
        cell.progressView.progress = Float(nowProgressed)
        
        return cell
    }
    
    @IBAction func backBtnAction(_ sender : Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func setBackBtn() {
        self.backBtn.tintColor = UIColor.purple
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 122
    }
    
}

