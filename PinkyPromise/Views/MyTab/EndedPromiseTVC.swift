//
//  EndedPromiseTVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/23/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class EndedPromiseTVC: UITableViewCell {

    @IBOutlet weak var promiseIcon: UIImageView!
    @IBOutlet weak var promiseName: UILabel!
    @IBOutlet weak var promiseStartTime: UILabel!
    @IBOutlet weak var promiseEndTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
//        self.layer.cornerRadius = 8.0
//        self.contentView.layer.cornerRadius = 8.0
//        self.contentView.layer.borderWidth = 2.0
//        self.contentView.layer.borderColor = UIColor.clear.cgColor
//        self.contentView.layer.masksToBounds = true
//        self.layer.shadowColor = UIColor.gray.cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
//        self.layer.shadowRadius = 5.0
//        self.layer.shadowOpacity = 1.0
//        self.layer.masksToBounds = true
        
        self.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        self.layer.cornerRadius = 8.0
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        
        self.promiseIcon.layer.cornerRadius = self.promiseIcon.frame.height/2
//        self.promiseIcon.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
    }

}
