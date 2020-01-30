//
//  UIView+Extension.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/15/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func applyShadow(radius: CGFloat, color: UIColor, offset: CGSize, opacity: Float) {
        self.layer.shadowRadius = radius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
    }
    
    func applyRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func applyBorder(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}


extension UIButton{

    var imageContentModeAspectFit : Bool{
        get{
            return self.imageView?.contentMode  == ContentMode.scaleAspectFit
        }
        set(newValue){
            if newValue{
                self.imageView?.contentMode = ContentMode.scaleAspectFit
            }
        }
    }
    
    func makeCircle() {
        self.layer.cornerRadius = self.layer.frame.height/2
    }
}

extension UILabel{
    
    func makeTwoLine() {
        self.lineBreakMode = .byWordWrapping
        self.numberOfLines = 2
    }
}

extension UIImageView {
    func makeCircle() {
        self.layer.cornerRadius = self.layer.frame.height/2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    
}
