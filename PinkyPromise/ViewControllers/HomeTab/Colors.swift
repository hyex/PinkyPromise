//
//  Colors.swift
//  PinkyPromise
//
//  Created by linc on 2020/02/01.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import Foundation
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
            return UIColor.appColor
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
