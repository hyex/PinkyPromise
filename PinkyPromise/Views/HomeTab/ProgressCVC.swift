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
    
    func setColor(progress: Int, name: String) {
        let color = MyColor(rawValue: name)
        
        if progress == -1 {
            self.progressButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
            self.progressButton.setTitleColor(color!.create, for: .normal)
        }
        else {
            self.progressButton.backgroundColor = color!.create.withAlphaComponent(CGFloat(Double(progress + 1) * 0.2))
            self.progressButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    func setProgressLabel(progress: Int, name: String) {
        let percent = 25 * progress
        self.progressButton.setTitle("\(percent)%", for: .normal)
    }
}
