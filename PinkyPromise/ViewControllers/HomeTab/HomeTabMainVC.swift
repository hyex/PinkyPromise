//
//  HomeTabMainVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/13/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit
import EventKit
import FSCalendar
import Floaty

class HomeTabMainVC: UIViewController {
    
//    fileprivate weak var calendar: FSCalendar!
//    fileprivate weak var eventLabel: UILabel!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var eventLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var addPromiseBtn: AddPromiseBtn!
//    weak var tableView: UITableView!
    private var promiseListforDates: [ProgressTable]!
    
    let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        return formatter
    }()
    
    var clickedProgress: [Any]!
    
    struct Promise {
        let promiseName: String
        let promiseIcon: String
        let promiseColor: String
        let progress: Int
    }
    
    struct Day {
        var day: Date
        var promise: [Promise]
    }
     
    var days: [PromiseAndProgress1] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "loggedIn") == false {
            print("here is AppDeletage.swift 1")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tempVC = storyboard.instantiateViewController(withIdentifier: "loginSB") as! UINavigationController
            tempVC.modalPresentationStyle = .fullScreen
            self.present(tempVC, animated: true, completion: nil)
            
            print("finished")
        }
        
        // initialize UI
        calendar.dataSource = self
        calendar.delegate = self

        calendar.appearance.eventOffset = CGPoint(x: 0, y: -7)
        calendar.register(MyCalendarCell.self, forCellReuseIdentifier: "cell")
                calendar.clipsToBounds = true // Remove top/bottom line
//
        calendar.swipeToChooseGesture.isEnabled = true // Swipe-To-Choose
//
        let scopeGesture = UIPanGestureRecognizer(target: calendar, action: #selector(calendar.handleScopeGesture(_:)));
        calendar.addGestureRecognizer(scopeGesture)

        let attributedText = NSMutableAttributedString(string: "")
        attributedText.append(NSAttributedString(string: "Today"))
        self.eventLabel.attributedText = attributedText

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nibName = UINib(nibName: "DayPromiseListTVC", bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "DayPromiseListCell")
        
        addPromiseBtn = AddPromiseBtn()
                
        addPromiseBtn.fabDelegate = self
        self.view.addSubview(addPromiseBtn)
         addPromiseBtn.translatesAutoresizingMaskIntoConstraints = false
        addPromiseBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        addPromiseBtn.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        addPromiseBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addPromiseBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true

        // data setting
        
        //        MyApi.shared.getProgressDataWithUid(userid: FirebaseUserService.currentUserID, completion: { (result) in
        //            DispatchQueue.main.sync {
        //                self.promiseListforDates = result
        //                print(self.promiseListforDates[0].progressDay ?? "data nil")
        //            }
        //        })
        //        MyApi.shared.getPromiseData(completion:  { (result) in
        //            DispatchQueue.main.async {
        //                result.forEach { (promise) in
        //                    <#code#>
        //                }
        //                self.promiseListforDates = result
        //                print(self.promiseListforDates[0].progressDay)
        //            }
        //        })
        setTableViewUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if UserDefaults.standard.bool(forKey: "loggedIn") == true {
            
            MyApi.shared.getAllHome { (result) in
                DispatchQueue.main.async {
                    self.days = result
                }
            }
        }

        tableView.reloadData()
        
    }
    
    @IBAction func addPromiseBtnAction(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "HomeNavigationController")
        
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .overCurrentContext
        
        self.present(vc, animated: false, completion: nil)
        
    }
}

extension HomeTabMainVC: FSCalendarDataSource, FSCalendarDelegate {
    
    // 날짜 선택 시 콜백
    public func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        changeDateFormatKR(date: date)
        self.tableView.reloadData()
    }
    
    // 날짜 선택 해제 시 콜백
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosion: FSCalendarMonthPosition) {
        
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position) as! MyCalendarCell
        cell.setBackgroundColor(progress: 0)
        configureVisibleCells()
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height
        self.eventLabel.frame.origin.y = calendar.frame.maxY + 10
        self.tableView.frame.origin.y = eventLabel.frame.maxY + 10
    }
    
    private func configureVisibleCells() {
        
        let cells = calendar.visibleCells() as! [MyCalendarCell]
        cells.forEach { (cell) in
            let date = calendar.date(for: cell)
            
            days.forEach { (day) in
                if self.dateFormat.string(from: day.Day) == self.dateFormat.string(from: date!) {
                    
                    var progress: Int = 0
                    for pm in day.PAPD {
                        for pm2 in pm.progressData.progressDegree {
                            progress += pm2
                        }
                    }
                    
                    if day.PAPD.count > 0
                    {
                        cell.setBackgroundColor(progress: ceil(Double(progress / day.PAPD.count)))
                    }else {
                        cell.setBackgroundColor(progress: ceil( 0.0 ))
                    }
                    
                }
            }
        }
    }
    
}


extension HomeTabMainVC {
    func changeDateFormatKR(date: Date) {
        
        let today = Date()
        
        if self.dateFormat.string(from: today) == self.dateFormat.string(from: date) {
            eventLabel.text = "Today"
        }
        else{
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "eee"
            
            dateFormat.locale = Locale(identifier: "ko_kr")
            dateFormat.timeZone = TimeZone(abbreviation: "KST")
            
            let cal = Calendar.current
            let components = cal.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: date)
            if let eventLabel = eventLabel {
                eventLabel.text = "\(components.month!)월 \(components.day!)일 \(dateFormat.string(from: date))요일"
            }
        }
    }
}

extension HomeTabMainVC: UITableViewDelegate {}
extension HomeTabMainVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let date = calendar.selectedDate ?? Date()
        var count = 0
        
        days.forEach { (day) in
            if self.dateFormat.string(from: day.Day) == self.dateFormat.string(from: date) {
                count = day.PAPD.count
            }
        }
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayPromiseListCell") as! DayPromiseListTVC

        let date = calendar.selectedDate ?? Date()
        cell.delegate = self
        days.forEach { (day) in
            if self.dateFormat.string(from: day.Day) == self.dateFormat.string(from: date) {
                cell.setName(name: day.PAPD[indexPath.row].promiseData.promiseName)
                cell.setIcon(name: day.PAPD[indexPath.row].promiseData.promiseIcon, color: day.PAPD[indexPath.row].promiseData.promiseColor)
                
                let interval = date.timeIntervalSince(day.PAPD[indexPath.row].promiseData.promiseStartTime)
                let idxDay = Int(interval/86400)
                cell.setProgress(promiseId: day.PAPD[indexPath.row].promiseData.promiseId, progressId: day.PAPD[indexPath.row].progressData.progressId, progressDegree: day.PAPD[indexPath.row].progressData.progressDegree[idxDay])
            }
        }
        
        cell.view.layer.backgroundColor = UIColor.appColor.withAlphaComponent(CGFloat(0.1)).cgColor
        //        cell.layer.borderWidth = 1
        cell.view.layer.cornerRadius = 8
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

extension HomeTabMainVC {
    func setTableViewUI() {
        // tableView 뷰 변경
        let dummyView = UIView(frame:CGRect(x: 0, y: 0, width: 0, height: 0))
        self.tableView.tableFooterView = dummyView;
        self.tableView.clipsToBounds = false
    }
}

extension HomeTabMainVC: FloatyDelegate {
    func emptyFloatySelected(_ floaty: Floaty) {
        
        let storyboard = UIStoryboard(name: "HomeTab", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController")
        
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .overCurrentContext
        
        self.present(vc, animated: false, completion: nil)
    }
}

extension HomeTabMainVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProgressVC" {
            let vc = segue.destination as! AddProgressVC
            vc.delegate = self
            vc.promiseId = self.clickedProgress[0] as? String
            vc.progressId = self.clickedProgress[1] as? String
            vc.selectedProgress = self.clickedProgress[2] as! Int
            vc.day = self.calendar.selectedDate
        }
    }
    
}

extension HomeTabMainVC: SendProgressDelegate {
    func sendProgress(data: Int) {
        self.tableView.reloadData()
    }
}

extension HomeTabMainVC: ClickProgressDelegate {
    func clickProgress(promiseId: String, progressId: String, progressDegree: Int) {
        self.clickedProgress = [promiseId, progressId, progressDegree]
        self.performSegue(withIdentifier: "ProgressVC", sender: nil)
//
//        let storyBoard = UIStoryboard(name: "HomeTab", bundle: nil)
//        let vc = storyBoard.instantiateViewController(identifier: "AddProgressVC")
//        self.present(vc, animated: false, completion: nil)
    }
}
