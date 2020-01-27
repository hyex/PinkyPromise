//
//  ColorCVC.swift
//  PinkyPromise
//
//  Created by linc on 2020/01/28.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

enum MyColor: String {
    case systemIndigo
    case systemRed
    case systemBlue
    case systemGreen
    case systemOrange
    case systemPurple
    case systemTeal
    case systemPink
    
    var create: UIColor {
        switch self {
        case .systemIndigo:
            return UIColor.systemIndigo
        case .systemRed:
            return UIColor.systemRed
        case .systemBlue:
            return UIColor.systemBlue
        case .systemGreen:
            return UIColor.systemGreen
        case .systemOrange:
            return UIColor.systemOrange
        case .systemPurple:
            return UIColor.systemPurple
        case .systemTeal:
            return UIColor.systemTeal
        case .systemPink:
            return UIColor.systemPink
        }
    }
    
}

class ColorCVC: UICollectionViewCell {

    @IBOutlet weak var colorButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func colorButtonAction(_ sender: Any) {
    }
    
    func setButtonColor(name: String) {
        let color = MyColor(rawValue: name)
        colorButton.tintColor = color?.create
        
        }
}
