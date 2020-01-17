//
//  LeeHJCustomSlider.swift
//  PinkyPromise
//
//  Created by linc on 2020/01/14.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class LeeHJCustomSlider: UISlider {

    // navigation 투명하게
//    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//    self.navigationController?.navigationBar.shadowImage = UIImage()
    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        self.thumbTintColor = UIColor.blue
//        self.currentThumbImage = UIImage()
//        print("init")
//    }
    
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
           let point = CGPoint(x: bounds.minX, y: bounds.midY)
           return CGRect(origin: point, size: CGSize(width: bounds.width, height: 13))
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
