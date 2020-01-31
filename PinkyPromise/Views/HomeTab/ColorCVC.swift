//
//  ColorCVC.swift
//  PinkyPromise
//
//  Created by linc on 2020/01/28.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

enum MyColor: String {
    case mySkyBlue
    case myDarkBlue
    case myPurple
    case myRedOrange
    case myGreen
    case myEmerald
    case myPink
    case myRed
    case myLightGreen
    case myYellowGreen
    case myYellow
    case myLightOrange
    
    var create: UIColor {
        switch self {
        case .mySkyBlue:
            return UIColor.mySkyBlue
        case .myDarkBlue:
            return UIColor.myDarkBlue
        case .myPurple:
            return UIColor.myPurple
        case .myRedOrange:
            return UIColor.myRedOrange
        case .myGreen:
            return UIColor.myGreen
        case .myEmerald:
            return UIColor.myEmerald
        case .myPink:
            return UIColor.myPink
        case .myRed:
            return UIColor.myRed
        case .myLightGreen:
            return UIColor.myLightGreen
        case .myYellowGreen:
            return UIColor.myYelloGreen
        case .myYellow:
            return UIColor.myYellow
        case .myLightOrange:
            return UIColor.myLightOrange
        }
    }
    
}

class ColorCVC: UICollectionViewCell {

    @IBOutlet weak var colorButton: UIButton!
    
    var colorName: String!
    var colorInt: Int!
    
    let colors: [String] = [ "mySkyBlue"
    , "myDarkBlue"
    , "myPurple"
    , "myRedOrange"
    , "myGreen"
    , "myEmerald"
    , "myPink"
    , "myRed"
    , "myLightGreen"
    , "myYellowGreen"
    , "myYellow"
    , "myLightOrange" ]
    
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
