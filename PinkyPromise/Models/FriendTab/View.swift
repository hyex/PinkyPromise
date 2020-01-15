//
//  View.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/15/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import Foundation
import UIKit

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
