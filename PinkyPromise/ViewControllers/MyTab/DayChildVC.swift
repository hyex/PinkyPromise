//
//  DayChildVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/14/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

struct promise {
    var color: UIColor
    var title: String
}

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
        day(date: "MON/1", promiseList: [
//            promise(color: .red, title: "red"),
//            promise(color: .yellow, title: "yellow"),
            promise(color: .blue, title: "blue")
        ]),
        day(date: "TUE/2", promiseList: [
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
            
//                print(rowData.promiseList.enumerated())
//
//                for (index, element) in rowData.promiseList.enumerated(){
//                    let view = UIView()
//                    let label = UILabel()
//                    label.text = rowData.promiseList[index].title
//                    view.backgroundColor = rowData.promiseList[index].color
//                    dayCell.promiseView.addSubview(view)
//                }
                
//                let viewsToDrow = viewsPerCell[indexPath.row]
                
                //Adding custom views to the stackView
//                print(rowData.promiseList.count )
                for index in 0 ... rowData.promiseList.count-1 {
//                    print(index)
                    let view = UIView()
                    let label = UILabel()
    
                    label.text = rowData.promiseList[index].title
                    view.addSubview(label)
                    view.backgroundColor = rowData.promiseList[index].color
                    var f = view.frame
                    f.size = CGSize(width: 300, height: 50)
                    view.frame = f
                    
                    dayCell.promiseView.addArrangedSubview(view)
                }
                
                cell = dayCell
            }
        
            return cell
    }
    
}


