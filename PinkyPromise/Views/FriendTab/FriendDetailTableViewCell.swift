//
//  FriendDetailTableViewCell.swift
//  PinkyPromise
//
//  Created by SEONYOUNG LEE on 2020/01/22.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class FriendDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var crownImg: UIImageView!
    
    @IBOutlet weak var friendProfileImg: UIImageView!
    @IBOutlet weak var friendNameLabel: UILabel!
    
    @IBOutlet weak var zeroCnt: UILabel!
    @IBOutlet weak var quarterCnt: UILabel!
    @IBOutlet weak var halfCnt: UILabel!
    
    @IBOutlet weak var threeQuarterCnt: UILabel!
    @IBOutlet weak var perfectCnt: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    override func awakeFromNib() {
        self.selectionStyle = .none
    }
    
}
