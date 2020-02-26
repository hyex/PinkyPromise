//
//  UIViewController+Extension.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/29/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

extension UIViewController {
    func simpleAlertWithCompletion(title: String, message: String, okCompletion: ((UIAlertAction) -> Void)?, cancelCompletion: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: okCompletion)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: cancelCompletion)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func simpleAlertWithCompletionOnlyOk(title: String, message: String, okCompletion: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: okCompletion)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    func simpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    func simpleAlertMessage(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
}
