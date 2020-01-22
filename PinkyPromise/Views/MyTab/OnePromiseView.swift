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
    }
    
    // 1
    convenience init(frame:CGRect, promise: Promise) {
        self.init(frame: frame) // 2
        self.promise = promise
        self.commonInit()
    }
    
    // 2
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
        print("required")
    }

    private func commonInit(){
        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        view.layer.cornerRadius = 4

        if promise != nil {
            let unwrappedPromise = promise!
            let selector = Selector("\(unwrappedPromise.promiseColor)Color")
            if UIColor.self.responds(to: selector) {
                let color = UIColor.self.perform(selector).takeUnretainedValue()
                view.backgroundColor = color as? UIColor
            } else {
                print("fail")
            }
        }

        self.addSubview(view)
    }
}
