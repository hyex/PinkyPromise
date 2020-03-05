//
//  IconCVC.swift
//  PinkyPromise
//
//  Created by linc on 2020/01/28.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class IconCVC: UICollectionViewCell {
    
    @IBOutlet weak var iconButton: UIButton!
    
    var iconName: String!
    var iconInt: Int!
    let icons: [String] = [ "promiseIcon_alchol", "promiseIcon_book", "promiseIcon_check", "promiseIcon_dumbell", "promiseIcon_heart", "promiseIcon_money", "promiseIcon_music", "promiseIcon_noSmoke", "promiseIcon_people",  "promiseIcon_sleep",  "promiseIcon_star", "promiseIcon_timer" ]
    var delegate: SelectedIconDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func iconButtonAction(_ sender: Any) {
        setSelectedBox()
        self.iconInt = icons.firstIndex(of: self.iconName)
        self.delegate.backSelectedIcon(data: self.iconName, num: self.iconInt)
    }
    
    func dismissSelectedBox() {
        self.layer.borderColor = nil
        self.layer.borderWidth = .nan
        self.layer.cornerRadius = .nan
    }
    
    func setSelectedBox() {
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 4
    }
    
    func setButtonIcon(name: String) {
        self.iconName = name
        let icon = UIImage(named: name)
        self.iconButton.setImage(icon, for: .normal)
    }
    
    func getButtonIcon() -> String {
        return iconName
    }
    
}
