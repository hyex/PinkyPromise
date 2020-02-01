//
//  AddPromiseBtn.swift
//  PinkyPromise
//
//  Created by linc on 2020/01/27.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit
import Floaty

class AddPromiseBtn: Floaty {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init() {
        super.init()
        self.buttonColor = UIColor.appColor
        self.plusColor = .white
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }

}
