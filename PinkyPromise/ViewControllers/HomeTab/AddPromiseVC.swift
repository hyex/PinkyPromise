//
//  AddPromiseVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/14/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit
import FSCalendar

protocol SendPromiseDelegate {
    func sendPromise()
}

class AddPromiseVC: UIViewController {
    
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    @IBOutlet weak var promiseTableView: UITableView!
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!

    let dummyView = UIView(frame:CGRect(x: 0, y: 0, width: 0, height: 0))
    
    //    private var isStartCalSelected: Bool!
    //    private var isEndCalSelected: Bool!
    private var selectedColor: Int! = 2
    private var selectedIcon: Int! = 0
    //    private var selectedFriends: [Int]!
    //    private var myFriends: [Int : [String]]! = [ : ]
    private var myFriends: [FriendData] = []
    
    private var selectedFriends: [FriendData] = []
    
    private var panaltyName: String!
    //   private var myFriendsImg: [UIImage]! = []
    
    private var todayDate: Date!
    
    let colors: [String] = [ "mySkyBlue"
        , "myDarkBlue"
        , "myPurple"
        , "myRedOrange"
        , "myGreen"
        , "myEmerald"
        , "myPink"
        , "myRed"
        , "myLightGreen"
        , "myYellowGreen"
        , "myYellow"
        , "myLightOrange" ]
    
    let icons: [String] = [  "promiseIcon_star", "promiseIcon_heart", "promiseIcon_dumbell", "promiseIcon_book", "promiseIcon_check",   "promiseIcon_money", "promiseIcon_music",  "promiseIcon_people",  "promiseIcon_sleep", "promiseIcon_timer", "promiseIcon_alchol", "promiseIcon_noSmoke" ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for modal
        definesPresentationContext = true
        
        // set UI
        setNavigationUI()
        setBackBtn()
        setNavigationUI()

        // detegate & dataSource
        promiseTableView.delegate = self
        promiseTableView.dataSource = self
        
        //data setting
        todayDate = Date(timeIntervalSince1970: floor(Date().timeIntervalSince1970/86400)*86400-32400)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFriendsData()
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        // var indexPath: NSIndexPath
        
        let textCell = promiseTableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! TextCellTVC
        
        let dateCell = promiseTableView.cellForRow(at: NSIndexPath(row: 2, section: 0) as IndexPath) as! PromiseInputTVC
        let dataName = textCell.getValue()
        
        let dataStartTime = Date(timeIntervalSince1970: ceil(dateCell.getFirstDate().timeIntervalSince1970/86400)*86400+21600)
        let dataEndTime = Date(timeIntervalSince1970: ceil(dateCell.getLastDate().timeIntervalSince1970/86400)*86400+21600)

        let dataColor = colors[selectedColor]
        let dataIcon = icons[selectedIcon]
        let dataUsers: Array<String> = {
            
            var friends = Array<String>()
            
            if friends.count >= 0 {
            selectedFriends.forEach { (friend) in
                friends.append(friend.id)
                }
            }
            else { friends = [] }
            return friends
        }()
        
        let promisePanalty = self.panaltyName ?? "벌칙없음"
        
        // error
        if dataName == "" { alertData(name: "title"); return }
        
        // network error
        if connectedToNetwork == false {
            alertData(name: "network"); return
        }

        let newPromise = PromiseTable(promiseName: dataName, promiseStartTime: dataStartTime, promiseEndTime: dataEndTime, promiseColor: dataColor, promiseIcon: dataIcon, promiseUsers: dataUsers, isPromiseAchievement: false, promisePanalty: promisePanalty, promiseId: AddPromiseService.shared.randomNonceString())
        
        AddPromiseService.shared.addPromiseData(newPromise)
        AddPromiseService.shared.addProgressData(newPromise)
        
        alertData(name: "save")
    }
}

// about UI
extension AddPromiseVC {
    func setBackBtn() {
        backBtn.tintColor = UIColor.appColor
        saveBtn.tintColor = UIColor.appColor
    }
    func setNavigationUI() {
        // navigation 투명하게
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    func setTableViewUI() {
        // tableView 뷰 변경
        promiseTableView.tableFooterView = dummyView;
        promiseTableView.clipsToBounds = false
        //self.promiseTableView.rowHeight = 100; 테이블뷰 높이 문제 해결 필요
    }
}


// about Data
extension AddPromiseVC {
    func getFriendsData() {
        self.myFriends = []
        AddPromiseService.shared.getUserData { (result) in
            var i = 0
             result[0].userFriends.forEach { (friendId) in
                AddPromiseService.shared.getUserDataWithUID(id: friendId) { (friend) in
                      let temp = FriendData(tag: i, id: friendId, name: friend.userName, image: friend.userImage, isChecked: nil)
                      self.myFriends.append(temp)
                    i += 1
                }
            }
        }
    }
    
    func alertData(name : String) {
        var text: String!
        var action: UIAlertAction!
        
        switch name {
        case "calendar":
            text = "365일이상 선택할 수 없습니다."
            action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
            break
        case "title":
            text = "제목을 입력해주세요."
            action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
            break
        case "network":
            text = "네트워크 연결을 확인해주세요."
            action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        default:
            text = "약속이 생성되었습니다!"
            action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (action) in
                self.dismiss(animated: false, completion: nil)
            }
            break
        }
        
        let dialog = UIAlertController(title: text, message: "", preferredStyle: .alert)
        dialog.addAction(action)
        self.present(dialog, animated: true, completion: nil)
    }
}

// initialize tableView
extension AddPromiseVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6;
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath.row) {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell") as! TextCellTVC
            cell.textField.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PromiseCustomCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell") as! PromiseInputTVC
            cell.setFirstDate(date: todayDate)
            cell.setLastDate(date: todayDate)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "calendarCell") as! PromiseInputTVC
            cell.calendar.delegate = self
            cell.calendar.dataSource = self
            cell.calendar.allowsMultipleSelection = true
            
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! FriendCellTVC
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "panaltyCell") as! PanaltyTVC
            return cell
        }
        // Configure the cells..
    }
}


// hide & show Calendar
extension AddPromiseVC {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return 75
        }
        else if indexPath.row == 3 {
            return self.view.frame.height/3.5
        }
        else { return 55 }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.row == 4 {
            self.performSegue(withIdentifier: "withFriendVC", sender: nil)
        }
        else if indexPath.row == 5 {
            self.performSegue(withIdentifier: "PanaltyVC", sender: nil)
        }
    }
}


// calendar logic
extension AddPromiseVC: FSCalendarDataSource {
    // 날짜 선택 시 콜백
    public func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let secondCell = promiseTableView.cellForRow(at: NSIndexPath(row: 2, section: 0) as IndexPath) as! PromiseInputTVC
        
        let cell = promiseTableView.cellForRow(at: NSIndexPath(row: 3, section: 0) as IndexPath) as! PromiseInputTVC
        
        if cell.firstDate == nil {
            
            cell.firstDate = date
            cell.datesRange = [cell.firstDate!]
            
            secondCell.setFirstDate(date: date)
            secondCell.setLastDate(date: date)
            
            //            print("datesRange contains: \(cell.datesRange!)")
            return
        }
            
        else if cell.firstDate != nil && cell.lastDate == nil {
            // handle the case of if the last date is less than the first date:
            if date <= cell.firstDate! {
                cell.calendar.deselect(cell.firstDate!)
                cell.firstDate = date
                secondCell.setFirstDate(date: date)
                secondCell.setLastDate(date: date)
                
                cell.datesRange = [cell.firstDate!]
                
                //                print("datesRange contains: \(cell.datesRange!)")
                return
            }
            
            let range = cell.datesRange(from: cell.firstDate!, to: date)
            
            cell.lastDate = range.last
            secondCell.setLastDate(date: range.last!)
            for day in range {
                calendar.select(day)
            }
            
            cell.datesRange = range
            
            if range.count > 365 {
                for day in cell.calendar.selectedDates {
                    cell.calendar.deselect(day)
                }
                cell.lastDate = nil
                cell.firstDate = nil
                
                cell.datesRange = []
                
                let cell = promiseTableView.cellForRow(at: NSIndexPath(row: 2, section: 0) as IndexPath) as! PromiseInputTVC
                cell.setFirstDate(date: todayDate)
                cell.setLastDate(date: todayDate)
                
                self.alertData(name: "calendar")
                calendar.setCurrentPage(todayDate, animated: true)
            }
            
            return
        }
        
        // both are selected:
        if cell.firstDate != nil && cell.lastDate != nil {
            for day in cell.calendar.selectedDates {
                cell.calendar.deselect(day)
            }
            cell.lastDate = nil
            cell.firstDate = nil
            
            cell.datesRange = []
            //            print("datesRange contains: \(cell.datesRange!)")
            
        }
        
    }
    
    // 날짜 선택 해제 시 콜백
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosion: FSCalendarMonthPosition) {
        let cell = promiseTableView.cellForRow(at: NSIndexPath(row: 3, section: 0) as IndexPath) as! PromiseInputTVC
        
        // both are selected:
        if cell.firstDate != nil && cell.lastDate != nil {
            for day in cell.calendar.selectedDates {
                cell.calendar.deselect(day)
            }
            cell.lastDate = nil
            cell.firstDate = nil
            
            cell.datesRange = []
            //            print("datesRange contains: \(cell.datesRange!)")
            
            let cell = promiseTableView.cellForRow(at: NSIndexPath(row: 2, section: 0) as IndexPath) as! PromiseInputTVC
            cell.setFirstDate(date: todayDate)
            cell.setLastDate(date: todayDate)
        }
    }
    
    //public func calendar
}

extension AddPromiseVC: FSCalendarDelegate {}

extension AddPromiseVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 30
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        textField.resignFirstResponder()
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    // Called just before UITextField is edited
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        print("textFieldDidBeginEditing: \((textField.text) ?? "Empty")")
        
    }
    
    // Called immediately after UITextField is edited
    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("textFieldDidEndEditing: \((textField.text) ?? "Empty")")
        
    }
    
}

extension AddPromiseVC: SendSelectedColorDelegate {
    
    func sendSelectedColor(data: String, num: Int) {
        let customCell = promiseTableView.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath) as! PromiseCustomCell
        let color = MyColor(rawValue: data)
        self.selectedColor = num
        customCell.colorButton.tintColor = color?.create
        customCell.iconButton.tintColor = color?.create
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CustomPromiseVC" {
            let vc = segue.destination as! AddColorVC
            //            let customCell = promiseTableView.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath) as! PromiseCustomCell
            vc.delegate = self
            vc.selectedColor = self.selectedColor
        }
        else if segue.identifier == "CustomIconVC" {
            let vc = segue.destination as! AddIconVC
            //            let customCell = promiseTableView.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath) as! PromiseCustomCell
            vc.delegate = self
            vc.selectedIcon = self.selectedIcon
        }
        else if segue.identifier == "withFriendVC" {
            let vc = segue.destination as! AddFriendsVC
            vc.delegate = self
            vc.withFriendsList = self.myFriends
            //            vc.myFriendsImg = self.myFriendsImg
        }
        else if segue.identifier == "PanaltyVC" {
            let vc = segue.destination as! AddPanaltyVC
            vc.delegate = self
            vc.panaltyName?.text = self.panaltyName ?? ""
        }
    }
}

extension AddPromiseVC: SendSelectedIconDelegate {
    
    func sendSelectedIcon(data: String, num: Int) {
        let customCell = promiseTableView.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath) as! PromiseCustomCell
        self.selectedIcon = num
        let icon = UIImage(named: icons[selectedIcon])?.withRenderingMode(.alwaysTemplate)
        icon?.withTintColor(customCell.colorButton.tintColor ?? UIColor.appColor)
        customCell.iconButton.setImage(icon, for: .normal)
    }
}

extension AddPromiseVC: SendSelectedFriendsDelegate {
    func sendSelectedFriends(data: [FriendData]) {
        selectedFriends = data
    }
}

extension AddPromiseVC: SendPanaltyNameDelegate {
    func sendPanaltyName(data: String) {
        self.panaltyName = data
    }
}

