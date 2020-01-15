//
//  DayTVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/14/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class DayTVC: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var promiseView: UIStackView!
    
    var promises:[promise] = []
    {
        didSet {
            self.updateStackView()
        }
    }
    
    func updateStackView() {
        for (index, element) in promises.enumerated(){
            print(index)
            let view = UIView()
            let label = UILabel()
            
            label.text = element.title
            view.addSubview(label)
            view.backgroundColor = element.color
            var f = view.frame
            f.size = CGSize(width: 300, height: 20)
            view.frame = f
            self.promiseView.addArrangedSubview(view)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dayLabel.makeTwoLine()
        
//        for (index, element) in promises.enumerated(){
//            print(index)
//            let view = UIView()
//            let label = UILabel()
//
//            label.text = element.title
//            view.addSubview(label)
//            view.backgroundColor = element.color
//            var f = view.frame
//            f.size = CGSize(width: 300, height: 20)
//            view.frame = f
//            self.promiseView.addArrangedSubview(view)
//        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
