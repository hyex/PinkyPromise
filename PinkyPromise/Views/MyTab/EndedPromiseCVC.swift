//
//  EndedPromiseCVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/27/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class EndedPromiseCVC: UICollectionViewCell {
    
    @IBOutlet weak var promiseIcon: UIImageView!
    @IBOutlet weak var promiseName: UILabel!
    @IBOutlet weak var promiseDuration: UILabel!
    @IBOutlet weak var promiseFriends: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        self.layer.cornerRadius = 8.0
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        
        self.promiseIcon.layer.cornerRadius = self.promiseIcon.frame.height/2
        self.promiseIcon.layer.masksToBounds = true
        self.promiseIcon.clipsToBounds = true
        
    }

    
}
