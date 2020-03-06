//
//  MyFriendTVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/30/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class MyFriendTVC: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.makeCircle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
