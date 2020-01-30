//
//  PromiseCustomCell.swift
//  PinkyPromise
//
//  Created by linc on 2020/01/27.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class PromiseCustomCell: UITableViewCell {

    @IBOutlet weak var colorButton: UIButton! = {
        let button = UIButton()
        button.tintColor = UIColor.systemPurple
        return button
    }()

    @IBOutlet weak var iconButton: UIButton! {
        didSet {
            iconButton.tintColor = colorButton.tintColor ?? UIColor.systemPurple
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func colorBtnAction(_ sender: Any) {
    }
    
    @IBAction func iconBtnAction(_ sender: Any) {
        
    }
    
}
