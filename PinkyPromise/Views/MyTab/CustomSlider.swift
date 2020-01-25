//
//  CustomSlider.swift
//  PinkyPromise
//
//  Created by linc on 2020/01/14.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class CustomSlider: UISlider {
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let point = CGPoint(x: bounds.minX, y: bounds.minY)
        return CGRect(origin: point, size: CGSize(width: bounds.width, height: bounds.height))
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.thumbTintColor = .clear
        self.layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = true
        self.minimumTrackTintColor = UIColor.appColor
    }
}
