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
    
    var progressInt: Int!
    var delegate: SelectedProgressDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        progressButton.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func progressBtnAction(_ sender: Any) {
        setSelectedBox()
        
        self.delegate.backSelectedProgress(data: self.progressInt)
        
    }
    
    func dismissSelectedBox() {
        self.layer.borderColor = nil
        self.layer.borderWidth = .nan
        self.layer.cornerRadius = .nan
    }
    
    func setSelectedBox() {
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 4
    }
    
    func setProgress(progress: Int) {
        self.progressInt = progress
    }
    
    func getProgress() -> Int {
        return progressInt
    }
}
