//
//  AddPromiseVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/14/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class AddPromiseVC: UITableViewController {

    let dummyView = UIView(frame:CGRect(x: 0, y: 0, width: 0, height: 0));
    
    @IBOutlet var promiseTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        setBackBtn()
        self.promiseTableView.tableFooterView = dummyView;
    }

}


extension AddPromiseVC {

    @objc func backBtnAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: false, completion: nil)
       }
    
    func setBackBtn() {
        var backBtn: UIBarButtonItem!
        //UIImage(named: "arrow.left")
        backBtn = UIBarButtonItem(title: "뒤로가기", style: .plain, target: self, action: #selector(backBtnAction(_:)))
//        backBtn = UIBarButtonItem(image: arrow.left, style: .plain, target: self, action: #selector(backBtnAction(_:)))
        
//        backBtn.tintColor = .b
        self.navigationItem.leftBarButtonItem  = backBtn
        
    }
}

