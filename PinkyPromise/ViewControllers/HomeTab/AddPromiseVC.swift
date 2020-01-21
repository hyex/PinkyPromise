//
//  AddPromiseVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/14/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class AddPromiseVC: UIViewController {

    @IBOutlet weak var backBtn: UIBarButtonItem!

    @IBOutlet weak var promiseTableView: UITableView!

    let dummyView = UIView(frame:CGRect(x: 0, y: 0, width: 0, height: 0))
    
    var isStartCalSelected: Bool!
    var isEndCalSelected: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // navigation 투명하게
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        setBackBtn()
        
        promiseTableView.delegate = self
        promiseTableView.dataSource = self
        
        self.promiseTableView.tableFooterView = dummyView;
        promiseTableView.clipsToBounds = false
        //self.promiseTableView.rowHeight = 100; 테이블뷰 높이 문제 해결 필요
        
        isStartCalSelected = true
        isEndCalSelected = true
        
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

extension AddPromiseVC: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: PromiseInputTVC;
        // print(indexPath.row, indexPath.section)
        switch (indexPath.row) {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "textCell") as! PromiseInputTVC
            break;
        case 1,3:
            cell = tableView.dequeueReusableCell(withIdentifier: "dateCell") as! PromiseInputTVC
            break;
        case 2,4:
            cell = tableView.dequeueReusableCell(withIdentifier: "calendarCell") as! PromiseInputTVC
            break;
        case 5,6:
            cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PromiseInputTVC
            break;
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell") as! PromiseInputTVC
            break;
        }
        
        cell.configure()

        return cell
        // Configure the cells..
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if !isStartCalSelected && indexPath.row == 2 {
            return 0.1
        }
        else if !isEndCalSelected && indexPath.row == 4 {
            return 0.1
        }
        else{
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.row == 1 {
            isStartCalSelected = isStartCalSelected ? false : true
            self.promiseTableView.beginUpdates()
            self.promiseTableView.endUpdates()
        }
        else if indexPath.row == 3 {
            isEndCalSelected = isEndCalSelected ? false : true
        self.promiseTableView.beginUpdates()
        self.promiseTableView.endUpdates()
        }
    }
}
