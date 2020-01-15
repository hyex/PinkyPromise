//
//  DayChildVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/14/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

struct day {
    var date: String
    var promiseList: [promise]
}

class DayChildVC: UIViewController {
    
    @IBOutlet weak var dayTableView: UITableView!
    
//    var promiseList1: [promise] = [
//        promise(color: .red, title: "red"),
//        promise(color: .yellow, title: "yellow"),
//        promise(color: .blue, title: "blue")
//    ]
    
    var dayList: [day] = [
        day(date: "MON  \n 1", promiseList: [
//            promise(color: .red, title: "red"),
//            promise(color: .yellow, title: "yellow"),
            promise(color: .blue, title: "blue")
        ]),
        day(date: "TUE  \n 2", promiseList: [
//            promise(color: .orange, title: "orange"),
            promise(color: .systemPink, title: "pink"),
            promise(color: .purple, title: "purple")
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayTableView.delegate = self
        dayTableView.dataSource = self
        dayTableView.estimatedRowHeight = 100
        dayTableView.rowHeight = UITableView.automaticDimension
        dayTableView.separatorColor = .clear
        dayTableView.reloadData()
    }

}

extension DayChildVC: UITableViewDelegate {
    
}

extension DayChildVC: UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
            if let dayCell = dayTableView.dequeueReusableCell(withIdentifier: "DayTVC", for: indexPath) as? DayTVC {
                
                let rowData = self.dayList[indexPath.row]
                
                dayCell.dayLabel.text = rowData.date
                
                dayCell.promises = rowData.promiseList
                print(dayCell.promises)

                cell = dayCell
            }
        
            return cell
    }
    
}


