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
    var progress : Double
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
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: false, completion: nil)
    }
    
    private func getDetailPromiseData(){
        self.friendsList = []
        
        if let promiseId = detailPromise?.promiseId {
            FriendTabDetailService.shared.getDataforDetailViewjr1(promiseID: promiseId) { (result) in
                print("result : ", result)
                for douc in result.friendsDetail {
                    var nowProgressed : Double
                    
                    let p1 = 1.0 * Double(douc.friendDegree[4])
                    let p2 = 0.75 * Double(douc.friendDegree[3])
                    let p3 = 0.5 * Double(douc.friendDegree[2])
                    let p4 = 0.25 * Double(douc.friendDegree[1])

                    nowProgressed = (p1 + p2 + p3 + p4) / result.promiseDay!
                    
                    self.friendsList.append(FriendDatailInfo(image: douc.friendImage, name: douc.friendName, degree: douc.friendDegree, progress: nowProgressed))
                }
                self.friendsList = self.friendsList.sorted(by: {$0.progress > $1.progress})
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
        
        if (rowData.image == "userDefaultImage") {
            cell.friendProfileImg.image = UIImage(named: "userDefaultImage")
        }else{
            //이미지 수정
            FirebaseStorageService.shared.getUserImageURLWithName(name: rowData.image, completion: { imgResult in
                switch imgResult {
                case .failure(let err):
                    print(err)
                    cell.friendProfileImg.image = UIImage(named: "userDefaultImage")
                case .success(let url):
                    let imgURL = URL(string: url)
                    do{
                        let data = try Data(contentsOf: imgURL!)
                        cell.friendProfileImg.image = UIImage(data: data)
                    } catch{
                        print("get img url failed")
                        cell.friendProfileImg.image = UIImage(named: "userDefaultImage")
                    }
                }
            })
        }
        
        //cell 값 setting
        cell.friendNameLabel.text = rowData.name
        cell.perfectCnt.text = String(rowData.degree[4])
        cell.threeQuarterCnt.text = String(rowData.degree[3])
        cell.halfCnt.text = String(rowData.degree[2])
        cell.quarterCnt.text = String(rowData.degree[1])
        cell.zeroCnt.text = String(rowData.degree[0])
        cell.progressView.tintColor = UIColor.appColor
        cell.progressView.progress = Float(rowData.progress)
        
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

