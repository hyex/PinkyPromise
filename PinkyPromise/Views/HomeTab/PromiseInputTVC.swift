//
//  PromiseInputTVC.swift
//  PinkyPromise
//
//  Created by linc on 2020/01/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit
import FSCalendar

class PromiseInputTVC: UITableViewCell {


    @IBOutlet weak var startDateLabel: UILabel!
    
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBOutlet weak var calendar: FSCalendar!
    
    var firstDate: Date!
    var lastDate: Date!
    var datesRange: [Date]!
    var date: Date!
    
    let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "eee"
        
        return formatter
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure() {
        
    }
}

extension PromiseInputTVC {
    
    func changeDateFormatKR(date: Date, dateLabel: UILabel!) {
        self.date = date
        
        let cal = Calendar.current
        let components = cal.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: date)
        
        if let dateLabel = dateLabel {
            dateLabel.text = "\(components.month!)월 \(components.day!)일 (\(self.dateFormat.string(from: date)))"
        }
    }
    
    func setFirstDate(date: Date) {
        self.firstDate = date
        changeDateFormatKR(date: firstDate, dateLabel: self.startDateLabel)
        print("---first---")
        print(self.firstDate)
    }
    
    func setLastDate(date: Date) {
        self.lastDate = date
        changeDateFormatKR(date: lastDate, dateLabel: self.endDateLabel)
        print("---last----")
        print(self.lastDate)
    }
    
    func getFirstDate() -> Date {
        return self.firstDate
    }
    
    func getLastDate() -> Date {
        return self.lastDate
    }
    
    func datesRange(from: Date, to: Date) -> [Date] {
        if from > to { return [Date]() }
        
        var tempDate = from
        var array = [tempDate]
        
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        return array
        
    }
}


extension DateFormatter {
    
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        formatter.calendar = Calendar(identifier: .iso8601)
        
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        formatter.locale = Locale(identifier: "ko_kr")
        
        return formatter
    }()
}


