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
        return CGRect(origin: point, size: CGSize(width: bounds.width, height: 20))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.frame.size.height = CGFloat(20.0)
        self.thumbTintColor = .clear
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
    }
}
