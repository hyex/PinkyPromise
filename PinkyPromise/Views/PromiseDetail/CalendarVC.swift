//
//  CalendarVC.swift
//  PinkyPromise
//
//  Created by SEONYOUNG LEE on 2020/03/07.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarVC: UITableViewCell {

    @IBOutlet weak var calendar: FSCalendar!
    
    var firstDate: Date!
    var lastDate: Date!
    var datesRange: [Date]!
    var date: Date!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "eee"
        
        return formatter
    }()
}

extension CalendarVC {

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

