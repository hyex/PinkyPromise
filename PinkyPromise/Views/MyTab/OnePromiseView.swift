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
    
    var vc : DayChildVC? = nil
    
    private var promise: PromiseTable? = nil
    private let xibName = "OnePromiseView"

//    fileprivate let promiseHeight: CGFloat = 30
    
    @IBOutlet weak var promiseName: UILabel!
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.promiseName.text = self.promise?.promiseName
    }
    
    // 1
    convenience init(frame:CGRect, promise: PromiseTable) {
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
    }

    private func commonInit(){
        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        view.layer.cornerRadius = 4

        if let unwrappedPromise = promise {
            let colorName = unwrappedPromise.promiseColor!
            view.backgroundColor = UIColor(named: colorName)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        view.addGestureRecognizer(tapGesture)

        self.addSubview(view)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if let controller = self.vc {
            controller.performSegue(withIdentifier: "promiseDetail", sender: self.promise!)
        }
    }
}

