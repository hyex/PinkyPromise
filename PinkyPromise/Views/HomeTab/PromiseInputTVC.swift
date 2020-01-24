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

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var calendar: FSCalendar!
    
    var date: Date!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initializeDate()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure() {
        
    }
}

extension PromiseInputTVC {
    func initializeDate() {
        date = Date()
        self.changeDateFormatKR(date: date)
    }
    func changeDateFormatKR(date: Date) {
        self.date = date
        
        let dateFormat = DateFormatter()
        
        dateFormat.locale = Locale(identifier: "ko_kr")
        dateFormat.timeZone = TimeZone(abbreviation: "KST")
        
        dateFormat.dateFormat = "eee"
        
        let cal = Calendar.current
        let components = cal.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: date)
        
        if let dateLabel = dateLabel {
            dateLabel.text = "\(components.month!)월 \(components.day!)일 \(dateFormat.string(from: date))요일"
        }
        if let timeLabel = timeLabel {
            dateFormat.dateFormat = "a h:mm"
            timeLabel.text = "\(dateFormat.string(from: date))"
        }
    }
    func getValue() -> Date {
        return self.date
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
