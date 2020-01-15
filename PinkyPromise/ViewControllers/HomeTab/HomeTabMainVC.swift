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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func addPromiseBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddPromiseVC") as! AddPromiseVC
        
        self.modalPresentationStyle = .currentContext
        self.modalTransitionStyle = .coverVertical
        
        self.present(vc, animated: false, completion: nil)
//        self.navigationController?.pushViewController(vc, animated: false)
    }
}
