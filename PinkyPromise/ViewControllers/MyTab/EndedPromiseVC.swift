//
//  EndedPromiseVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/18/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class EndedPromiseVC: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var endedPromiseTableView: UITableView!
    
    var promiseList: [PromiseData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.tintColor = .black
        self.endedPromiseTableView.delegate = self
        self.endedPromiseTableView.dataSource = self
        
        // 날짜가 끝났고, 성취률 100%인 약속들만 넘겨오는 함수 만들기 Api 에서
        MyApi.shared.allPromise(completion: { result in
            DispatchQueue.main.async {
                self.promiseList = result
                self.endedPromiseTableView.reloadData()
            }
        })
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    

}

extension EndedPromiseVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 133
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let shadowView = UIView()
//        let gradient = CAGradientLayer()
//        gradient.frame.size = CGSize(width: tableView.bounds.width, height: 15)
//
//        let stopColor = UIColor.gray.cgColor
//        let startColor = UIColor.white.cgColor
//
//        gradient.colors = [stopColor, startColor]
//        gradient.locations = [0.0,0.8]
//
//        shadowView.layer.addSublayer(gradient)
//
//        return shadowView
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }

    
}


extension EndedPromiseVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.promiseList.count
        
    }

    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EndedPromiseTVC", for: indexPath) as! EndedPromiseTVC
        
        let rowData = promiseList[indexPath.section]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let today = Date()
        let startDate = rowData.promiseStartTime
        let endDate = rowData.promiseEndTime
        
//        cell.promiseIcon = rowData.promiseIcon
        cell.promiseName.text = rowData.promiseName
        cell.promiseStartTime.text = "From : " + dateFormatter.string(from: startDate)
        cell.promiseEndTime.text = "To : " + dateFormatter.string(from: endDate)

        let selector = Selector("\(rowData.promiseColor)Color")
        if UIColor.self.responds(to: selector) {
            var color = UIColor.self.perform(selector).takeUnretainedValue()
//            color = color.withAlphaComponent(0.2)
            let cgColor = color.cgColor
            cell.layer.borderColor = cgColor as! CGColor
            
        } else {
            print("get color Fail")
        }
        
        cell.layer.borderWidth = 1
        
        return cell
    }
    
}


