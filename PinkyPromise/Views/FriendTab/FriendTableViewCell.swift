//
//  FriendTableViewCell.swift
//  PinkyPromise
//
//  Created by SEONYOUNG LEE on 2020/01/15.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    @IBOutlet weak var friendProfileImg: UIImageView!
    
    @IBOutlet weak var friendNameLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
