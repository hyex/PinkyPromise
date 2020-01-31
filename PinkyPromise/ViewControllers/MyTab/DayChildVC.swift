//
//  DayChildVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/14/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class DayChildVC: UIViewController {
    
    @IBOutlet weak var dayTableView: UITableView!
    
    var dayList: [DayAndPromise]? {
        didSet { dayTableView.reloadData() }
    }
    
//    var firstIndex: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMyPageData()
        setUpTableView()
    }

    private func setUpTableView() {
        self.dayTableView.delegate = self
        self.dayTableView.dataSource = self
        self.dayTableView.rowHeight = UITableView.automaticDimension;
        self.dayTableView.estimatedRowHeight = 100;

    }
    
    // 통신
    private func getMyPageData() {
        MyApi.shared.getPromiseData10ToNow(completion: { result in
            DispatchQueue.main.async {
                self.dayList = result
            }
        })
    }
}

extension DayChildVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dayList = dayList else { return 0 }
        return dayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = dayTableView.dequeueReusableCell(withIdentifier: "DayTVC", for: indexPath) as! DayTVC
        cell.vc = self
        
        if let list = self.dayList {
            let rowData = list[indexPath.row]
            cell.setPromise(day: rowData)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yy mm dd"
            let today = Date()
            if dateFormatter.string(from: list[indexPath.row].Day) == dateFormatter.string(from: today) {
//                firstIndex = indexPath
                self.dayTableView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
        
        
        return cell
    }
    
    //****선영 추가 부분****
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("in prepare func")
        if segue.identifier == "promiseDetail"{
            let promiseDetail = sender as? PromiseTable
            if promiseDetail != nil{
                let PromiseDetailVC = segue.destination as? PromiseDetailVC
                if PromiseDetailVC != nil {
                    PromiseDetailVC?.promiseDetail = promiseDetail
                }
            }
        }
    }
    
    
    
}

extension DayChildVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let dayList = dayList else { return 0 }
        let height:CGFloat = CGFloat(dayList[indexPath.row].promiseData.count * 43 + 10)
        
        return height
//        return UITableView.automaticDimension;
    }
}

  
