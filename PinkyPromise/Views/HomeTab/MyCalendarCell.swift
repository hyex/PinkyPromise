//
//  MyCalendarCell.swift
//  PinkyPromise
//
//  Created by linc on 2020/01/26.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit
import FSCalendar

class MyCalendarCell: FSCalendarCell {
        required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        self.shapeLayer.isHidden = true
        
        let view = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.12)
        self.backgroundView = view;
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
    }
    
//    override func configureAppearance() {
//        super.configureAppearance()
//        // Override the build-in appearance configuration
//        if self.isPlaceholder {
//            self.eventIndicator.isHidden = false
//            self.titleLabel.textColor = UIColor.lightGray
//        }
//    }

}
