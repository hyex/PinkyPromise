//
//  FriendCellTVC.swift
//  PinkyPromise
//
//  Created by linc on 2020/01/29.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class FriendCellTVC: UITableViewCell {

    @IBOutlet weak var friendIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let image = UIImage(named: "withFriends")?.withRenderingMode(.alwaysTemplate)
        friendIcon.image = image
        
        friendIcon.tintColor = UIColor.myPurple
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
