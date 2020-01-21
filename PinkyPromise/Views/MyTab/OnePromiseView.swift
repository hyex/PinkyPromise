//
//  OnePromiseView.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/21/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import Foundation
import UIKit

class OnePromiseView: UIView {
    
    private var promise: Promise? = nil
    private let xibName = "OnePromiseView"

//    fileprivate let promiseHeight: CGFloat = 30
    
    @IBOutlet weak var promiseName: UILabel!
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.promiseName.text = self.promise?.promiseName
        if promise != nil {
                    let unwrappedPromise = promise!
//                    let backgroundColor = "UIColor" + unwrappedPromise.promiseColor
//            let selector = Selector("\(name)Color")
//            if UIColor.self.responds(to: selector) {
//                let color = UIColor.self.perform(selector).takeUnretainedValue()
//                return (color as! UIColor)
//            } else {
//                return nil
//            }
//                    print(backgroundColor)
//                }
//                else {
//                    print(promise!)
                }
            
//        let color = UIColor.
//        color.colorNamed
        let color = UIColor(named: "blackColor")
        print(color)
        self.backgroundColor = UIColor(named: "Darkred")
//            UIColor().color
//
    }
    
    convenience init(frame:CGRect, promise: Promise) {
        self.init(frame: frame)
        self.promise = promise
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit(){
        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
//        view.frame = CGRect(x: 0.0, y: 0.0, width: 240.0, height: 30.0)
//        view.backgroundColor = UIColor(named: "White")
        
//        if promise != nil {
//            var unwrappedPromise = promise!
//            let backgroundColor = "UIColor" + unwrappedPromise.promiseColor
//            print(backgroundColor)
//        }
//        else {
//            print(promise!)
//        }

        
        self.addSubview(view)
        
    }
}
