//
//  DayPromiseListTVC.swift
//  PinkyPromise
//
//  Created by linc on 2020/01/26.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

protocol ClickProgressDelegate {
    func clickProgress(promiseId: String, progressId: String, progressDegree: Int, cell: DayPromiseListTVC)
}

class DayPromiseListTVC: UITableViewCell {
    
    var promiseId: String! = "0"
    var progressId: String! = "0"
    var progressDegree: Int = 0
    var delegate: ClickProgressDelegate!
    
    @IBOutlet weak var promiseIcon: UIImageView! = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "ebook")
        imgView.image?.withTintColor(UIColor.myPurple)
        return imgView
    }()
    
    @IBOutlet weak var promiseName: UILabel! = {
        let label = UILabel()
        label.text = "trash"
        return label
    }()
    
    @IBOutlet weak var promiseProgress: UIButton! = {
        let button = UIButton()
        return button
    }()
    
    @IBOutlet weak var view: UIView!
    
    var myProgress: MyProgress = MyProgress()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    @IBAction func progressBtnAction(_ sender: Any) {

        self.delegate.clickProgress(promiseId: self.promiseId, progressId: self.progressId, progressDegree: self.progressDegree, cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func setName(name: String) {
        promiseName.text? = name
    }
    
    func setIcon(name: String, color: String) {
        
        let icon = UIImage(named: name)?.withRenderingMode(.alwaysTemplate)
        
        let colors = MyColor(rawValue: color)
        icon?.withTintColor(colors?.create ?? UIColor.appColor)
        
        self.promiseIcon.image = icon
        promiseIcon.tintColor = colors?.create
    }
    
    func setProgress(promiseId: String, progressId: String, progressDegree: Int){
        
        self.promiseId = promiseId
        self.progressId = progressId
        self.progressDegree = progressDegree
        
        if progressDegree < 0 {
            self.promiseProgress.setBackgroundImage(myProgress.progressIcons[0], for: .normal)
        } else {
            self.promiseProgress.setBackgroundImage(myProgress.progressIcons[progressDegree], for: .normal)
        }
        

    }
}
