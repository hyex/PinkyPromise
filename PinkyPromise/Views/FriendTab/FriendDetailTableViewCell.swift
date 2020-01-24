//
//  FriendDetailTableViewCell.swift
//  PinkyPromise
//
//  Created by SEONYOUNG LEE on 2020/01/22.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class FriendDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var friendProfileImg: UIImageView!
    @IBOutlet weak var friendNameLabel: UILabel!
    
    @IBOutlet weak var successCntLabel: UILabel!
    
    @IBOutlet weak var failCntLabel: UILabel!
    
    @IBOutlet weak var longestCntLabel: UILabel!
    
    @IBOutlet weak var progressBar: NSLayoutConstraint!
    
}
