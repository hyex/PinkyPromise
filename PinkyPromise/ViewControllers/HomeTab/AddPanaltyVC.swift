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
    
    @IBOutlet var bigView: UIView!
    
    @IBOutlet weak var textField: UITextField!
    
    var delegate: SendPanaltyNameDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.smallView.layer.shadowColor = UIColor.black.cgColor
        self.smallView.layer.masksToBounds = false
        self.smallView.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.smallView.layer.shadowRadius = 8
        self.smallView.layer.shadowOpacity = 0.3
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(AddPanaltyVC.dismissPage(sender:)))
        self.bigView.addGestureRecognizer(gesture)
        self.textField.delegate = self
    }
    
    @objc func dismissPage(sender: UIGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }    // MARK: - Navigation

    @IBAction func cancelBtnAction(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func saveBtnAction(_ sender: Any) {
        self.delegate.sendPanaltyName(data: panaltyName?.text ?? "")
        dismiss(animated: false, completion: nil)
    }
    
}

extension AddPanaltyVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 30
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        textField.resignFirstResponder()
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    // Called just before UITextField is edited
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        print("textFieldDidBeginEditing: \((textField.text) ?? "Empty")")
        
    } 
    
    // Called immediately after UITextField is edited
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        print("textFieldDidEndEditing: \((textField.text) ?? "Empty")")
        
    }
}
