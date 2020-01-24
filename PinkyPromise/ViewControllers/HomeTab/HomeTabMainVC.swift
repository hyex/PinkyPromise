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

    @IBOutlet weak var addPromiseBtn: UIButton!
    @IBOutlet weak var nearPromiseLabel: UILabel!
    @IBOutlet weak var nearPromise: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
                
        calendar.delegate = self
        calendar.dataSource = self
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
    private func initView() {
        setupLabel()
        setupBtn()
    }
}

extension HomeTabMainVC {
    
    func setupLabel() {
        
        let yourAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20),
            .foregroundColor: UIColor.black,
            .underlineColor: UIColor.darkGray,
            .underlineStyle: NSUnderlineStyle.thick.rawValue]
        
        let attributeString = NSMutableAttributedString(string: "가장 가까운 나의 약속", attributes: yourAttributes)
        nearPromiseLabel.attributedText = attributeString
            
        
        nearPromise.backgroundColor = .lightGray
    }
    
    func setupBtn() {
//        addPromiseBtn.layer.cornerRadius = addPromiseBtn.layer.frame.height/2
        addPromiseBtn.makeCircle()
    }
    
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        print(dateFormatter.string(from: date))
    }
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-DD-YYYY"
        dateFormatter.timeZone = TimeZone.current
        let dateStr = dateFormatter.string(from: date)
        return "01-10-2020".contains(dateStr) ? UIImage(named: "cloud") : nil
    }
}
