//
//  AddPromiseVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/14/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit
import FSCalendar



class AddPromiseVC: UIViewController {
    
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    @IBOutlet weak var promiseTableView: UITableView!
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    let dummyView = UIView(frame:CGRect(x: 0, y: 0, width: 0, height: 0))
    
    var isStartCalSelected: Bool!
    var isEndCalSelected: Bool!
    var selectedColor: Int! = 0
    var selectedIcon: Int! = 0
    
    let colors: [String] = [ "systemPurple", "systemRed", "systemBlue", "systemGreen", "systemOrange", "systemIndigo", "systemTeal", "systemPink" ]
    let icons: [String] = [ "star", "book", "drugs", "english", "gym", "list", "meditation", "sleep" ]
    
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
        
        // logic
        isStartCalSelected = true
        isEndCalSelected = true
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        // var indexPath: NSIndexPath
        
        let textCell = promiseTableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! TextCellTVC
        
        let dateStartCell = promiseTableView.cellForRow(at: NSIndexPath(row: 2, section: 0) as IndexPath) as! PromiseInputTVC
        let dateEndCell = promiseTableView.cellForRow(at: NSIndexPath(row: 4, section: 0) as IndexPath) as! PromiseInputTVC
        
        let dataName = textCell.getValue()
        let dataStartTime = dateStartCell.getValue()
        let dataEndTime = dateEndCell.getValue()
        let isDataAlarm = true
        let dataColor = colors[selectedColor]
        let dataAlarmContent = ""
        let dataIcon = icons[selectedIcon]
        let dataAchievement = 0.0
        let dataUsers: Array<String>? = []
        let isPromiseAchievement = false
        let promisePanalty = ""
        
        let newPromise = PromiseTable(promiseName: dataName, isPromiseAlarm: isDataAlarm, promiseStartTime: dataStartTime, promiseEndTime: dataEndTime, promiseColor: dataColor, promiseAlarmContent: dataAlarmContent, promiseIcon: dataIcon, promiseAchievement: dataAchievement, promiseUsers: dataUsers, isPromiseAchievement: isPromiseAchievement, promisePanalty: promisePanalty)
        
        MyApi.shared.addPromiseData(newPromise)
        
        self.dismiss(animated: false, completion: nil)
    }
}

// about UI
extension AddPromiseVC {
    func setBackBtn() {
        backBtn.tintColor = .black
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

// initialize tableView
extension AddPromiseVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7;
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
        case 2,4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell") as! PromiseInputTVC
            return cell
        case 3,5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "calendarCell") as! PromiseInputTVC
            cell.calendar.delegate = self
            cell.calendar.dataSource = self
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell") as! PromiseInputTVC
            return cell
        }
        // Configure the cells..
    }
}


// hide & show Calendar
extension AddPromiseVC {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if !isStartCalSelected && indexPath.row == 3 {
            return 0.01
        }
        else if !isEndCalSelected && indexPath.row == 5 {
            return 0.01
        }
        else{
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.row == 2 {
            isStartCalSelected = isStartCalSelected ? false : true
            self.promiseTableView.beginUpdates()
            self.promiseTableView.endUpdates()
        }
        else if indexPath.row == 4 {
            isEndCalSelected = isEndCalSelected ? false : true
            self.promiseTableView.beginUpdates()
            self.promiseTableView.endUpdates()
        }
    }
}


// calendar logic
extension AddPromiseVC: FSCalendarDataSource {
    // 날짜 선택 시 콜백
    public func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let firstCalCell = promiseTableView.cellForRow(at: NSIndexPath(row: 3, section: 0) as IndexPath) as! PromiseInputTVC
        let secondCalCell = promiseTableView.cellForRow(at: NSIndexPath(row: 5, section: 0) as IndexPath) as! PromiseInputTVC
        
        if firstCalCell.calendar == calendar {
            let cell = promiseTableView.cellForRow(at: NSIndexPath(row: 2, section: 0) as IndexPath) as! PromiseInputTVC
            cell.changeDateFormatKR(date: date)
        }
        if secondCalCell.calendar == calendar {
            let cell = promiseTableView.cellForRow(at: NSIndexPath(row: 4, section: 0) as IndexPath) as! PromiseInputTVC
            cell.changeDateFormatKR(date: date)
        }
        
        //let cell = promiseTableView.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath)
        // promiseTableView.indexPathForSelectedRow
        
        //print(dateFormatter.string(from: date))
    }
    
    // 날짜 선택 해제 시 콜백
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosion: FSCalendarMonthPosition) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        print(dateFormatter.string(from: date))
    }
    
    //public func calendar
}

extension AddPromiseVC: FSCalendarDelegate {}

extension AddPromiseVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 15
        
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
    }
}

extension AddPromiseVC: SendSelectedIconDelegate {
    
    func sendSelectedIcon(data: String, num: Int) {
        let customCell = promiseTableView.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath) as! PromiseCustomCell
        self.selectedIcon = num
        customCell.iconButton.setImage(UIImage(named: icons[selectedIcon]), for: .normal)
    }
}
