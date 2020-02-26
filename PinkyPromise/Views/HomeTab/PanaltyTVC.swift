//
//  PanaltyTVC.swift
//  PinkyPromise
//
//  Created by linc on 2020/01/30.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class PanaltyTVC: UITableViewCell {

    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var panaltyIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let image = UIImage(named: "panalty")?.withRenderingMode(.alwaysTemplate)
        panaltyIcon.image = image
        
        panaltyIcon.tintColor = UIColor.myPurple
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func addBtnAction(_ sender: Any) {
        
    }
    
}
