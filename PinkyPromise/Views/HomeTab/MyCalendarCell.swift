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
        view.backgroundColor = UIColor.appColor.withAlphaComponent(0)
        self.backgroundView = view;
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
    }
    
    func setBackgroundWithIconColor(progress: Double, name: String) {
        let colorName = name
        let color = MyColor(rawValue: colorName)
        let iconColor = color?.create ?? UIColor.appColor
        let alpha = progress * 0.25
        self.backgroundView?.backgroundColor = iconColor.withAlphaComponent(CGFloat(alpha))
    }
    
    func setBackgroundColor(progress: Double) {
        let alpha = progress * 0.25
        self.backgroundView?.backgroundColor = UIColor.appColor.withAlphaComponent(CGFloat(alpha))
    }

}
