//
//  DayPromiseListTVC.swift
//  PinkyPromise
//
//  Created by linc on 2020/01/26.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class DayPromiseListTVC: UITableViewCell {
    
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
    
    @IBOutlet weak var promiseProgress: UIButton!
    
    @IBOutlet weak var view: UIView!
    
    var myProgress: MyProgress = MyProgress()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    @IBAction func progressBtnAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "HomeTab", bundle: nil)
        let tempVC = storyboard.instantiateViewController(withIdentifier: "ProgressVC") as! UINavigationController
        tempVC.modalPresentationStyle = .overCurrentContext
        
        let VC = storyboard.instantiateViewController(withIdentifier: "HomeTabMainVC") as! UINavigationController
        VC.present(tempVC, animated: true, completion: nil)
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
        
        promiseProgress.setImage(myProgress.progressIcons[progress], for: .normal)
    }
}
