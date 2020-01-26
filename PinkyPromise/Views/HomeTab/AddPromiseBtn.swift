//
//  AddPromiseBtn.swift
//  PinkyPromise
//
//  Created by linc on 2020/01/27.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit
import Floaty

class AddPromiseBtn: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let floaty: Floaty = Floaty()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        floaty.buttonColor = UIColor.systemPurple
        floaty.plusColor = .white
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
}
