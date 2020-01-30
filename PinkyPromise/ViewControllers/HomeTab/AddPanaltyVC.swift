//
//  AddPanaltyVC.swift
//  PinkyPromise
//
//  Created by linc on 2020/01/30.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

protocol SendPanaltyNameDelegate {
    func sendPanaltyName(data: String)
}

class AddPanaltyVC: UIViewController {

    @IBOutlet weak var cancelBtn: UIButton!

    @IBOutlet weak var saveBtn: UIButton!

    @IBOutlet weak var smallView: UIView!
    
    @IBOutlet weak var panaltyName: UITextField!
    
    var delegate: SendPanaltyNameDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.smallView.layer.shadowColor = UIColor.black.cgColor
        self.smallView.layer.masksToBounds = false
        self.smallView.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.smallView.layer.shadowRadius = 8
        self.smallView.layer.shadowOpacity = 0.3
    }
    
    // MARK: - Navigation

    @IBAction func cancelBtnAction(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func saveBtnAction(_ sender: Any) {
        self.delegate.sendPanaltyName(data: panaltyName?.text ?? "")
        dismiss(animated: false, completion: nil)
    }
    
}
