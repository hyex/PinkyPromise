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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        progressButton.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func progressBtnAction(_ sender: Any) {
//        setSelectedBox()
//
//        self.delegate.backSelectedProgress(data: self.progressInt)
        
    }
//    func setButtonColor() {
//        self.progressButton.tintColor = UIColor.appColor.withAlphaComponent(CGFloat(progressInt/5))
//    }
//    func dismissSelectedBox() {
//        self.layer.borderColor = nil
//        self.layer.borderWidth = .nan
//        self.layer.cornerRadius = .nan
//    }
//
//    func setSelectedBox() {
//        self.layer.borderColor = UIColor.gray.cgColor
//        self.layer.borderWidth = 1
//        self.layer.cornerRadius = 4
//    }
    
    func setProgress(progress: Int) {
        self.progressInt = progress
    }
    
    func getProgress() -> Int {
        return progressInt
    }
    
    func setColor(progress: Int) {
        if progress <= 0 {
            self.backgroundColor = UIColor.lightGray
        } else {
            self.backgroundColor = UIColor.appColor.withAlphaComponent(CGFloat(progress))
        }
    }
    
    func setProgressLabel() {
        let percent = 25 * progressInt
        self.progressButton.setTitle("\(percent)%", for: .normal)
    }
}
