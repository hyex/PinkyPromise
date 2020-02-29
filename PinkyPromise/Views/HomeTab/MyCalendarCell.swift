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
        view.backgroundColor = UIColor.appColor.withAlphaComponent(0.12)
        self.backgroundView = view;
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
    }
    
    func setBackgroundColor(progress: Double) {
        let alpha = progress * 0.2
//        print(alpha)
//        if alpha > 0.4 {
//            self.appearance.titleDefaultColor = UIColor(white: 1.0, alpha: 1.0)
//           self.appearance.titlePlaceholderColor = UIColor(white: 1.0, alpha: 1.0)
//        }
//        else if alpha <= 0.4 && alpha > 0.01 {
//            self.appearance.titlePlaceholderColor = UIColor.darkText
//        }
        
        self.backgroundView?.backgroundColor = UIColor.appColor.withAlphaComponent(CGFloat(alpha))
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
