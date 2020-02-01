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
        self.navigationController?.navigationBar.isHidden = true
        initView()
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

extension MyTabMainVC {
    func initView() {
        addSwipeGesture()
    }
    
    func addSwipeGesture() {
            
            let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            
            leftSwipe.direction = .left
            rightSwipe.direction = .right
            
            dayChildView.addGestureRecognizer(leftSwipe)
            promiseChildView.addGestureRecognizer(rightSwipe)
        }
        
        @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
                
            if (sender.direction == .left) {
                segmentedControl.selectedSegmentIndex = 1
                dayChildView.isHidden = true
                promiseChildView.isHidden = false
            }
                
            if (sender.direction == .right) {
                segmentedControl.selectedSegmentIndex = 0
                dayChildView.isHidden = false
                promiseChildView.isHidden = true
            }
        }
}
