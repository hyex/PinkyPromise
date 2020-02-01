//
//  ColorCVC.swift
//  PinkyPromise
//
//  Created by linc on 2020/01/28.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class ColorCVC: UICollectionViewCell {

    @IBOutlet weak var colorButton: UIButton!
    
    var colorName: String!
    var colorInt: Int!
    
    var delegate: SelectedColorDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func colorButtonAction(_ sender: Any) {
        setSelectedBox()
        self.colorInt = colors.firstIndex(of: self.colorName)
        self.delegate.backSelectedColor(data: self.colorName, num: self.colorInt)
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
    
    func setButtonColor(name: String) {
        self.colorName = name
        let color = MyColor(rawValue: name)
        self.colorButton.tintColor = color?.create
    }
    
    func getButtonColor() -> String {
        return colorName
    }
}
