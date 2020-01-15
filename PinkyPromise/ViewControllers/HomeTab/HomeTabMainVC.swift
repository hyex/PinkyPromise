//
//  HomeTabMainVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/13/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class HomeTabMainVC: UIViewController {

    @IBOutlet weak var addPromiseBtn: UIButton!
    @IBOutlet weak var nearPromiseLabel: UILabel!
    @IBOutlet weak var nearPromise: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
    }
    
    @IBAction func addPromiseBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "HomeNavigationController") as! UIViewController
        
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .overCurrentContext
        
        self.present(vc, animated: false, completion: nil)
    }
}

// MARK: Init
extension HomeTabMainVC {
    private func initView() {
        setupLabel()
        setupBtn()
    }
}

extension HomeTabMainVC {
    
    func setupLabel() {
        
        let yourAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20),
            .foregroundColor: UIColor.black,
            .underlineColor: UIColor.darkGray,
            .underlineStyle: NSUnderlineStyle.thick.rawValue]
        
        let attributeString = NSMutableAttributedString(string: "가장 가까운 나의 약속", attributes: yourAttributes)
        nearPromiseLabel.attributedText = attributeString
            
        
        nearPromise.backgroundColor = .lightGray
    }
    
    func setupBtn() {
        addPromiseBtn.setTitleColor(.white, for: .normal)
        addPromiseBtn.backgroundColor = .blue
//        addPromiseBtn.layer.cornerRadius = addPromiseBtn.layer.frame.height/2
        addPromiseBtn.makeCircle()
    }
    
}
