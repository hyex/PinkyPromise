//
//  signUpVC.swift
//  PinkyPromise
//
//  Created by apple on 2020/01/23.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class signUpVC: UIViewController {

    @IBOutlet weak var idBtn: UITextField!
    @IBOutlet weak var passwordBtn: UITextField!
    @IBOutlet weak var emailBtn: UITextField!
    @IBOutlet weak var startBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    Get the new view controller using segue.destination.
//    Pass the selected object to the new view controller.
    }
    
}
