//
//  TextCellTVC.swift
//  PinkyPromise
//
//  Created by linc on 2020/01/23.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class TextCellTVC: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getValue() -> String {
        return textField.text ?? ""
    }
}
