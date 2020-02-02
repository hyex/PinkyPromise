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
    var degree : [Int]
//    var perfect : String
//    var threeQuarter : String
//    var half : String
//    var quarter : String
//    var zero : String
}

import UIKit

class FriendTabDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var promiseTitleLabel: UILabel!
    @IBOutlet weak var friendDatailTableView: UITableView!
 
    var friendsList : [FriendDatailInfo] = [] {
        didSet {friendDatailTableView.reloadData()}
    }

    var detailPromise : PromiseWithFriend? = nil {
        didSet {
            print("detailPromise : ", self.detailPromise!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setBackBtn()
        setPromiseName()
        addSwipeGesture()
    }
    
    func setUpTableView(){
        friendDatailTableView.delegate = self
        friendDatailTableView.dataSource = self
        friendDatailTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDetailPromiseData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func getDetailPromiseData(){
        print("in getDatailPromiseData")
        
        if let promiseId = detailPromise?.promiseId {
            MyApi.shared.getDataforDetailViewjr1(promiseID: promiseId) { (result) in
                print("result : ", result)
                for douc in result.friendsDetail {
                    self.friendsList.append(FriendDatailInfo(image: douc.friendImage, name: douc.friendName, degree: douc.friendDegree))
                }
            }
        }else{
            print("promise id is nil")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendDetailTableViewCell", for: indexPath) as! FriendDetailTableViewCell
        
        let rowData = self.friendsList[indexPath.row]
        
        cell.crownImg.image = UIImage(named: "yellowcrown")
        if(!(indexPath.row == 0)) {
            cell.crownImg.isHidden = true
        }
        
        cell.friendProfileImg.layer.cornerRadius = cell.friendProfileImg.frame.width/2
        cell.friendProfileImg.clipsToBounds = true
        
        //이미지 수정
        FirebaseStorageService.shared.getUserImageURLWithName(name: rowData.image, completion: { imgResult in
            switch imgResult {
            case .failure(let err):
                print(err)
                cell.friendProfileImg.image = UIImage(named: "user_male")
            case .success(let url):
                let imgURL = URL(string: url)
                do{
                    let data = try Data(contentsOf: imgURL!)
                    cell.friendProfileImg.image = UIImage(data: data)
                } catch{
                    print("get img url failed")
                    cell.friendProfileImg.image = UIImage(named: "user_male")
                }
            }
        })
        
        //cell 값 setting
        cell.friendNameLabel.text = rowData.name
        cell.perfectCnt.text = String(rowData.degree[4])
        cell.threeQuarterCnt.text = String(rowData.degree[3])
        cell.halfCnt.text = String(rowData.degree[2])
        cell.quarterCnt.text = String(rowData.degree[1])
        cell.zeroCnt.text = String(rowData.degree[0])

        var nowProgressed : Double
        let p1 = 1.0 * Double(rowData.degree[4])
        let p2 = 0.75 * Double(rowData.degree[3])
        let p3 = 0.5 * Double(rowData.degree[2])
        let p4 = 0.25 * Double(rowData.degree[1])

        nowProgressed = (p1 + p2 + p3 + p4) / 30.0
        cell.progressView.tintColor = UIColor.appColor
        cell.progressView.progress = Float(nowProgressed)
        
        return cell
    }
    
    @IBAction func backBtnAction(_ sender : Any) {
        self.backBtn.tintColor = UIColor.appColor
        self.dismiss(animated: false, completion: nil)
    }
    
    func setBackBtn() {
        self.backBtn.tintColor = UIColor.purple
    }
    
    func setPromiseName() {
        self.promiseTitleLabel.text = self.detailPromise?.promiseName
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 122
    }
    
    func addSwipeGesture() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        rightSwipe.direction = .right
        friendDatailTableView.addGestureRecognizer(rightSwipe)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .right) {
            self.dismiss(animated: false, completion: nil)}
    }
    
}

