//
//  PromiseCVC.swift
//  PinkyPromise
//
//  Created by apple on 2020/01/13.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit


class PromiseCVC: UICollectionViewCell {
    
    @IBOutlet weak var appSlider: LeeHJCustomSlider!
    @IBOutlet weak var showSliderValue: UILabel!
    @IBOutlet weak var promiseName: UILabel!
    
    var days:[day] = [] {
        didSet {
            self.updateStackView()
        }
    }
    
    func updateStackView() {
        
    }

    @IBAction func sliderValueChanged(_ sender: Any?) {
        self.showSliderValue.text = "\(self.appSlider.value)"
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = UIColor.white

        self.layer.cornerRadius = 8.0

        self.contentView.layer.cornerRadius = 8.0
        self.contentView.layer.borderWidth = 2.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath

    }
    
//    init() {
//        appSlider.minimumTrackTintColor = UIColor(named: "Red")
//        appSlider.maximumTrackTintColor = UIColor(named: "DarkRed")
//    }
//    appSlider.mininumTrackTintColor = UIColor(named: "Red")
//    appSlider.maximunTrackTintColor = UIColor(named: "DarkRed")
}
