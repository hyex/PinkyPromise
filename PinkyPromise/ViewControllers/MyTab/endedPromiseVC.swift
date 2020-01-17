//
//  endedPromiseVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/18/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class endedPromiseVC: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.tintColor = .black

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
