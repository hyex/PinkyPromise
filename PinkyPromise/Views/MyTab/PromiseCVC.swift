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

    @IBAction func sliderValueChanged(_ sender: Any?) {
        self.showSliderValue.text = "\(self.appSlider.value)"
        
        // 레이블의 위치도 변경해야함
        var sliderWidth = self.appSlider.frame.width
        var temp = CGFloat(self.appSlider.value/10)*sliderWidth
//        print(sliderWidth)
//        print(type(of: sliderWidth))
        self.showSliderValue.layer.position.x = CGFloat(14.0) + temp
//        self.showSliderValue.layer.position.x = self.appSlider.layer.position.x + self.appSlider.value
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.showSliderValue.layer.position.x = CGFloat(14.0 + 5.0 )

        self.backgroundColor = UIColor.white

        self.layer.cornerRadius = 8.0

        self.contentView.layer.cornerRadius = 8.0
        self.contentView.layer.borderWidth = 2.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        
        self.appSlider.thumbTintColor = .clear
        
        promiseName.makeTwoLine()
//        promiseName.lineBreakMode = .byWordWrapping
//        promiseName.numberOfLines = 2
        
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath

    }
    
//    init() {
//        appSlider.minimumTrackTintColor = UIColor(named: "Red")
//        appSlider.maximumTrackTintColor = UIColor(named: "DarkRed")
//    }
//    appSlider.mininumTrackTintColor = UIColor(named: "Red")
//    appSlider.maximunTrackTintColor = UIColor(named: "DarkRed")
}
