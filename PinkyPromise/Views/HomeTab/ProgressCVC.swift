//
//  ProgressCVC.swift
//  PinkyPromise
//
//  Created by linc on 2020/02/02.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class ProgressCVC: UICollectionViewCell {
    
    @IBOutlet weak var progressButton: UIButton!
    
    var progressInt: Int! = 0
    
    var delegate: SelectedProgressDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        progressButton.layer.cornerRadius = 4
    }
 
    @IBAction func progressButtonAction(_ sender: Any) {
        self.delegate.backSelectedProgress(num: progressInt)
    }
    
    func setProgress(progress: Int) {
        self.progressInt = progress
    }
    
    func getProgress() -> Int {
        return progressInt
    }
    
    func setColor(progress: Int) {
        if progress == -1 {
            self.progressButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        }
        else {
            self.progressButton.backgroundColor = UIColor.appColor.withAlphaComponent(CGFloat(Double(progress + 1) * 0.2))
        }
    }
    
    func setProgressLabel(progress: Int) {
        let percent = 25 * progress
        self.progressButton.setTitle("\(percent)%", for: .normal)
    }
}
