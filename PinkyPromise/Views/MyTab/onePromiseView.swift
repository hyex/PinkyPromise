//
//  MemberView.swift
//  MultiLineCell
//
//  Created by DevKang on 2020/01/21.
//  Copyright © 2020 DevKang. All rights reserved.
//
// [참고자료] https://seonift.github.io/2018/05/23/Swift-커스텀-UIView-제작하기-with-Xib/
// [참고자료] https://jinios.github.io/ios/2018/04/15/customView_init/

import UIKit

class OnePromiseView: UIView {
    private var promise:promise? = nil
    @IBOutlet weak var memberLabel: UILabel!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.memberLabel.text = self.promise?.title
    }
    
    convenience init(frame:CGRect, promise:promise) {
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
        let view = Bundle.main.loadNibNamed(NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
}
