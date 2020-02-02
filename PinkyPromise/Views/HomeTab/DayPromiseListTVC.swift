//
//  DayPromiseListTVC.swift
//  PinkyPromise
//
//  Created by linc on 2020/01/26.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

protocol ClickProgressDelegate {
    func clickProgress(promiseId: String, progressId: String)
}

class DayPromiseListTVC: UITableViewCell {
    
    var promiseId: String! = "0"
    var progressId: String! = "0"
    var delegate: ClickProgressDelegate!
    
    @IBOutlet weak var promiseIcon: UIImageView! = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "star")
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

        self.delegate.clickProgress(promiseId: self.promiseId, progressId: self.progressId)
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
        icon?.withTintColor(UIColor(named: color) ?? UIColor.myPurple)
        
        promiseIcon.image = icon
    }
    
    func setProgress(progress: Int){
        
        self.tag = progress == -1 ? 0 : 4 - progress
        self.promiseProgress.setBackgroundImage(myProgress.progressIcons[self.tag], for: .normal)

    }
}
