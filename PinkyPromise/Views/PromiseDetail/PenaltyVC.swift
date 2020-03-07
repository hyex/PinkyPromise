//
//  PenaltyVC.swift
//  PinkyPromise
//
//  Created by SEONYOUNG LEE on 2020/03/07.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class PenaltyVC: UITableViewCell {
    
    @IBOutlet weak var PenaltyImg: UIImageView!
    @IBOutlet weak var Penalty: UILabel!
    @IBOutlet weak var PenaltyLabel: UILabel!
    
    override func awakeFromNib() {
           self.selectionStyle = .none
    }
}
