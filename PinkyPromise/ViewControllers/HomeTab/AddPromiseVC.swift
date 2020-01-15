//
//  AddPromiseVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/14/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class AddPromiseVC: UITableViewController {

    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    let dummyView = UIView(frame:CGRect(x: 0, y: 0, width: 0, height: 0));
    
    @IBOutlet var promiseTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // navigation 투명하게
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        setBackBtn()
        self.promiseTableView.tableFooterView = dummyView;
        promiseTableView.clipsToBounds = false
        //self.promiseTableView.rowHeight = 100; 테이블뷰 높이 문제 해결 필요
    }

    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}


extension AddPromiseVC {

    func setBackBtn() {
        backBtn.tintColor = .black
    }
}

