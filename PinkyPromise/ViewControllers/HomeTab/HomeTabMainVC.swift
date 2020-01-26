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

class HomeTabMainVC: UIViewController {

//    @IBOutlet weak var addPromiseBtn: UIButton!
//    @IBOutlet weak var nearPromiseLabel: UILabel!
//    @IBOutlet weak var nearPromise: UILabel!
    fileprivate weak var calendar: FSCalendar!
    fileprivate weak var eventLabel: UILabel!
    
    override func loadView() {
            
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.white
        self.view = view
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 50, width: self.view.frame.size.width, height: 33))
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 27.0)
        titleLabel.attributedText = NSAttributedString(string: "PinkyPromise")
        view.addSubview(titleLabel)
        
        let height: CGFloat = UIDevice.current.model.hasPrefix("iPad") ? 400 : 300
        let calendar = FSCalendar(frame: CGRect(x: 0, y: titleLabel.frame.maxY + 28, width: view.frame.size.width, height: height))
        calendar.dataSource = self
        calendar.delegate = self
//        calendar.allowsMultipleSelection = true
        view.addSubview(calendar)
        self.calendar = calendar
           
        calendar.appearance.headerTitleColor = UIColor.systemPurple
        calendar.appearance.weekdayTextColor = UIColor.darkText
        calendar.appearance.borderSelectionColor = UIColor.systemPurple
        calendar.appearance.selectionColor = UIColor.clear
        calendar.appearance.titleSelectionColor = UIColor.darkText
        
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        
        calendar.appearance.todayColor = UIColor.systemPurple
        
        calendar.appearance.eventOffset = CGPoint(x: 0, y: -7)
        calendar.register(MyCalendarCell.self, forCellReuseIdentifier: "cell")
   //        calendar.clipsToBounds = true // Remove top/bottom line
           
        calendar.swipeToChooseGesture.isEnabled = true // Swipe-To-Choose
           
        let scopeGesture = UIPanGestureRecognizer(target: calendar, action: #selector(calendar.handleScopeGesture(_:)));
           calendar.addGestureRecognizer(scopeGesture)
           
           
        let label = UILabel(frame: CGRect(x: 0, y: calendar.frame.maxY + 10, width: self.view.frame.size.width, height: 50))
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        self.view.addSubview(label)
        self.eventLabel = label
           
        let attributedText = NSMutableAttributedString(string: "")
           attributedText.append(NSAttributedString(string: "Today"))
        self.eventLabel.attributedText = attributedText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        initView()
//        calendar.delegate = self
//        calendar.dataSource = self
    }
    
    @IBAction func addPromiseBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "HomeNavigationController") as! UIViewController
        
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .overCurrentContext
        
        self.present(vc, animated: false, completion: nil)
    }
}

// MARK: Init
extension HomeTabMainVC {
//    private func initView() {
//        setupLabel()
//        setupBtn()
//    }
}

extension HomeTabMainVC {
    
//    func setupLabel() {
//
//        let yourAttributes: [NSAttributedString.Key: Any] = [
//            .font: UIFont.systemFont(ofSize: 20),
//            .foregroundColor: UIColor.black,
//            .underlineColor: UIColor.darkGray,
//            .underlineStyle: NSUnderlineStyle.thick.rawValue]
//
//        let attributeString = NSMutableAttributedString(string: "Today", attributes: yourAttributes)
//
//        nearPromiseLabel.attributedText = attributeString
//        }
//
//    func setupBtn() {
////        addPromiseBtn.layer.cornerRadius = addPromiseBtn.layer.frame.height/2
//        addPromiseBtn.makeCircle()
//    }
}



extension HomeTabMainVC: FSCalendarDataSource, FSCalendarDelegate {
    
    // 날짜 선택 시 콜백
    public func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        print(dateFormatter.string(from: date))
    }
    
    // 날짜 선택 해제 시 콜백
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosion: FSCalendarMonthPosition) {

    }
//    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM-DD-YYYY"
//        dateFormatter.timeZone = TimeZone.current
//        let dateStr = dateFormatter.string(from: date)
//        return "01-10-2020".contains(dateStr) ? UIImage(named: "cloud") : nil
//    }
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
}
