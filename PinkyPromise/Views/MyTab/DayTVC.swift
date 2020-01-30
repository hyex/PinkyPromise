//
//  DayTVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/14/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class DayTVC: UITableViewCell {
    
    var vc:DayChildVC? = nil

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var promiseView: UIStackView!
    
//    fileprivate let promiseHeight: CGFloat = 30
    
    func setPromise(day: Day){
        
        let date = Date(timeIntervalSinceNow: TimeInterval(day.day*86400))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "EEEEEEE\nd"
        
        DispatchQueue.main.async {
            
            self.dayLabel.text = dateFormatter.string(from: date)
            if(day.day == 0) {
                
                self.dayLabel.layer.masksToBounds = true
                self.dayLabel.layer.cornerRadius = self.dayLabel.layer.frame.height/2
                self.dayLabel.backgroundColor = UIColor.purple.withAlphaComponent(0.2)

            }
            
            if self.promiseView.arrangedSubviews.count != day.promise.count {
                for promise in day.promise {
                    let viewToAdd = OnePromiseView(frame: CGRect.zero, promise: promise)
                    viewToAdd.vc = self.vc
                    self.promiseView.addArrangedSubview(viewToAdd)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dayLabel.makeTwoLine()
        self.selectionStyle = .none
//        dayLabel.lineBreakMode = .byWordWrapping
//        dayLabel.numberOfLines = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
