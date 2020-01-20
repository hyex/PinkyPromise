//
//  PromiseInputTVC.swift
//  PinkyPromise
//
//  Created by linc on 2020/01/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

struct PromiseSchedule {
    var startDate: Date;
    var endDate: Date;
}

class PromiseInputTVC: UITableViewCell {

    @IBOutlet weak var textField: UITextField!

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var schedule: PromiseSchedule!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let now = Date()
        let date = DateFormatter()
        
        date.locale = Locale(identifier: "ko_kr")
        date.timeZone = TimeZone(abbreviation: "KST")

        date.dateFormat = "eee"

        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: now)
            
        if let dateLabel = dateLabel {
            dateLabel.text = "\(components.month!)월 \(components.day!)일 \(date.string(from: now))요일"
        }
        if let timeLabel = timeLabel {
            date.dateFormat = "a h:mm"
            timeLabel.text = "\(date.string(from: now))"
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure() {
        
    }
}

extension DateFormatter {
    
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd "
        
        formatter.calendar = Calendar(identifier: .iso8601)
        
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        formatter.locale = Locale(identifier: "ko_kr")
        
        return formatter
    }()
}
