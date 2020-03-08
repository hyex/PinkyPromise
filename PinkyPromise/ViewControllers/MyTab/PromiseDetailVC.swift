//
//  promiseDatailVC.swift
//  PinkyPromise
//
//  Created by SEONYOUNG LEE on 2020/01/28.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit
import FSCalendar

struct Friend{
    var profileImg : String
    var name : String
}

class PromiseDetailVC: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var coloredPromiseIcon: UIImageView!
    @IBOutlet weak var promiseNameLabel: UILabel!
    
    @IBOutlet weak var promiseInfoTableView: UITableView!
    @IBOutlet weak var promiseFriendTableView: UITableView!
    
    let queue:DispatchQueue = DispatchQueue(label: "queue")
    let myGroup: DispatchGroup = DispatchGroup()
    
    var promiseFriends : [FriendDatailInfo] = []{
        didSet{ promiseFriendTableView.reloadData() }
    }
    
    var promiseDetail : PromiseTable? = nil {
        didSet{
            print("promiseDetail : ", promiseDetail!.promiseUsers)
        }
    }
    
    var progressTable: ProgressTable? = nil {
        didSet{
            print("pogressTable is nil")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in viewDidLoad")
        setUpTableView()
        setBackBtn()
        setPromieName()
    }
    
    func setPromieName(){
        promiseNameLabel.text = promiseDetail?.promiseName
    }
    
    func setUpTableView(){
        promiseInfoTableView.delegate = self
        promiseInfoTableView.dataSource = self
        promiseInfoTableView.tableFooterView = UIView()
        
        promiseFriendTableView.delegate = self
        promiseFriendTableView.dataSource = self
        promiseFriendTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("in viewWillAppear")
        getPromiseFriendData()

        
        self.myGroup.enter()
        getProgressData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("in viewWillDisappear")
        //        self.dismiss(animated: false, completion: nil)
        //        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backBtnAction(_ sender : Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func setBackBtn() {
        self.backBtn.tintColor = UIColor.purple
    }
}

extension PromiseDetailVC : UITableViewDelegate {
    
}

extension PromiseDetailVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCnt : Int = 0
        
        if(tableView == promiseInfoTableView) {
            rowCnt = 3
        }else if(tableView == promiseFriendTableView){
            rowCnt = self.promiseFriends.count
        }
        return rowCnt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy / MM / dd"
//        dateFormatter.locale = Locale.init(identifier: "kr_KR")
        
        if(tableView == promiseInfoTableView){
            switch (indexPath.row) {
                
            case 0:
                let dateCell = tableView.dequeueReusableCell(withIdentifier: "PromiseDateVC") as! PromiseDateVC
                
                if let start = promiseDetail?.promiseStartTime {
                    dateCell.setFirstDate(date: start)
                } else {
                    print("date to string fail")
                    dateCell.startDateLabel.text = "-"
                }
                
                if let final = promiseDetail?.promiseEndTime {
                    dateCell.setLastDate(date: final)
                }else{
                    print("date to string fail")
                    dateCell.finalDateLabel.text = "-"
                }
                
                return dateCell
            case 1 :
                let calendarCell = tableView.dequeueReusableCell(withIdentifier: "CalendarVC") as! CalendarVC
                calendarCell.calendar.delegate = self
                calendarCell.calendar.dataSource = self
                calendarCell.calendar.appearance.eventOffset = CGPoint(x: 0, y: -7)
                calendarCell.calendar.register(MyCalendarCell.self, forCellReuseIdentifier: "calendarCell")
                return calendarCell
                
            default :
                let penaltyCell = tableView.dequeueReusableCell(withIdentifier: "PenaltyVC") as! PenaltyVC
                
                if (promiseDetail?.promisePanalty != "") {
                    penaltyCell.PenaltyLabel.text = promiseDetail?.promisePanalty
                }else{
                    penaltyCell.PenaltyLabel.text = "벌칙 없음"
                }
                
                penaltyCell.PenaltyImg.tintColor = UIColor.appColor
                return penaltyCell
            }
        }else {
            let friendCell = tableView.dequeueReusableCell(withIdentifier: "PromiseFriendTVC", for: indexPath) as! PromiseFriendTVC
            
            let rowData = self.promiseFriends[indexPath.row]
            
            
            friendCell.friendProfileImg.layer.cornerRadius = friendCell.friendProfileImg.frame.width/2
            friendCell.friendProfileImg.clipsToBounds = true
            
            if (rowData.image == "userDefaultImage") {
                friendCell.friendProfileImg.image = UIImage(named: "userDefaultImage")
            }else{
                FirebaseStorageService.shared.getUserImageURLWithName(name: rowData.image, completion: { imgResult in
                    switch imgResult {
                    case .failure(let err):
                        print(err)
                        friendCell.friendProfileImg.image = UIImage(named: "userDefaultImage")
                    case .success(let url):
                        let imgURL = URL(string: url)
                        do{
                            let data = try Data(contentsOf: imgURL!)
                            friendCell.friendProfileImg.image = UIImage(data: data)
                        } catch{
                            print("get img url failed")
                            friendCell.friendProfileImg.image = UIImage(named: "userDefaultImage")
                        }
                    }
                })
            }
            
            friendCell.friendNameLabel.text = rowData.name
            
            return friendCell
        }
    }
    
    func getPromiseFriendData() {
        if let promiseId = promiseDetail?.promiseId {
            PromiseDetailService.shared.getDataforDetailViewjrWithoutMe(promiseID: promiseId) { (result) in
                for douc in result.friendsDetail {
                    self.promiseFriends.append(FriendDatailInfo(image: douc.friendImage, name: douc.friendName, degree: douc.friendDegree))
                }
            }
        } else {
            print("promise id is nil")
        }
        
        print(self.promiseFriends)
    }
    
    func getProgressData() {
        if let promiseId = promiseDetail?.promiseId {
        PromiseDetailService.shared.getProgressDataWithPromiseId(promiseid: promiseId) { (result) in
                DispatchQueue.main.async {
                    self.progressTable = result[0]
                    let cell = self.promiseInfoTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! CalendarVC
                    cell.calendar.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == promiseFriendTableView){
            return 60
        } else {
            if indexPath.row == 0 {
                return 80
            }
            else if indexPath.row == 1 {
                return self.view.frame.height/4
            }
        }
        return 50
    }
    
    func addSwipeGesture() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        rightSwipe.direction = .right
        promiseInfoTableView.addGestureRecognizer(rightSwipe)
        promiseFriendTableView.addGestureRecognizer(rightSwipe)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .right) {
            self.dismiss(animated: false, completion: nil)
        }
    }
}

extension PromiseDetailVC: FSCalendarDataSource, FSCalendarDelegate {
    
    // 날짜 선택 시 콜백
    public func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
//        changeDateFormatKR(date: date)
    }
    
    // 날짜 선택 해제 시 콜백
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosion: FSCalendarMonthPosition) {
        
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "calendarCell", for: date, at: position) as! MyCalendarCell
        cell.setBackgroundColor(progress: 0.0)
        configureVisibleCell(date: date, cell: cell)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
//        self.calendar.frame.size.height = bounds.height
    }
    
    private func configureVisibleCell(date: Date, cell: MyCalendarCell) {
        let date = Date(timeInterval: 86400, since: date)
        let datindex = Int(date.timeIntervalSince1970 - promiseDetail!.promiseStartTime.timeIntervalSince1970) / 86400
        let progressDegree: [Int] = progressTable?.progressDegree ?? []
        if datindex >= 0 && datindex < progressDegree.count {
            let progress = progressDegree[datindex]
            if progress == -1 {
                cell.setBackgroundColor(progress: 0.0)
            } else {
                cell.setBackgroundColor(progress: Double(progress))
            }
        }
    }
}

