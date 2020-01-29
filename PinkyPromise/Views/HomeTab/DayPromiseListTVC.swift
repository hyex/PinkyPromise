//
//  DayPromiseListTVC.swift
//  PinkyPromise
//
//  Created by linc on 2020/01/26.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class DayPromiseListTVC: UITableViewCell {

    @IBOutlet weak var promiseIcon: UIImageView! = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "trash")
        return imgView
    }()
    @IBOutlet weak var promiseName: UILabel! = {
        let label = UILabel()
        label.text = "trash"
        return label
    }()
    
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func setName(name: String) {
        promiseName.text? = name
    }
    func setIcon(name: String) {
        promiseIcon = UIImageView(image: UIImage(named: "trash")) 
        
    }
}
