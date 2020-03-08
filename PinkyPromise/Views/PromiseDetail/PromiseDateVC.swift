//
//  PromiseDateCell.swift
//  PinkyPromise
//
//  Created by SEONYOUNG LEE on 2020/03/07.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class PromiseDateVC: UITableViewCell {

    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var finalDate: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var finalDateLabel: UILabel!
    
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
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

extension PromiseDateVC {
    
    func changeDateFormatKR(date: Date, dateLabel: UILabel!) {
        let date = Date(timeInterval: -86400, since: date)
        let cal = Calendar.current
        let components = cal.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: date)
        
        if let dateLabel = dateLabel {
            dateLabel.text = "\(components.year!)년 \(components.month!)월 \(components.day!)일 (\(self.dateFormat.string(from: date)))"
        }
    }
    
    func setFirstDate(date: Date) {
        changeDateFormatKR(date: date, dateLabel: self.startDateLabel)
    }
    
    func setLastDate(date: Date) {
        changeDateFormatKR(date: date, dateLabel: self.finalDateLabel)
    }
//
//    func getFirstDate() -> Date {
//        return self.startDate
//    }
//
//    func getLastDate() -> Date {
//        return self.finalDate
//    }
    
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

