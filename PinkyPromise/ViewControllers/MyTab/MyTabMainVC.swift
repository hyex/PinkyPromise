//
//  MyTabMainVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/13/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class MyTabMainVC: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!

    @IBOutlet weak var dayChildView: UIView!
    @IBOutlet weak var promiseChildView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayChildView.isHidden = false
        promiseChildView.isHidden = true

    }
    
    
    @IBAction func indexChanged(_ sender: Any) {
        
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            dayChildView.isHidden = false
            promiseChildView.isHidden = true
        case 1:
            dayChildView.isHidden = true
            promiseChildView.isHidden = false
        default:
            break
        }
    }
    
}
