//
//  ProgressCVC.swift
//  PinkyPromise
//
//  Created by linc on 2020/02/02.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit



class ProgressCVC: UICollectionViewCell {
    

    @IBOutlet weak var progressView: UIView!
    
    @IBOutlet weak var progressLabel: UILabel!
    
    var progressInt: Int! = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        progressView.layer.cornerRadius = 4
    }
 

    
    func setProgress(progress: Int) {
        self.progressInt = progress
    }
    
    func getProgress() -> Int {
        return progressInt
    }
    
    func setColor(progress: Int) {
        if progress == -1 {
            self.progressView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        }
        else {
            self.progressView.backgroundColor = UIColor.appColor.withAlphaComponent(CGFloat(Double(progress + 1) * 0.2))
        }
    }
    
    func setProgressLabel(progress: Int) {
        let percent = 25 * progress
        self.progressLabel.text = "\(percent)%"
    }
}
