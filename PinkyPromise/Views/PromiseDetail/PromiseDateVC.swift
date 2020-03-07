//
//  PromiseDateCell.swift
//  PinkyPromise
//
//  Created by SEONYOUNG LEE on 2020/03/07.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class PromiseDateVC: UITableViewCell {

    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var finalDate: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var finalDateLabel: UILabel!
    
    override func awakeFromNib() {
        self.selectionStyle = .none
    }
}
