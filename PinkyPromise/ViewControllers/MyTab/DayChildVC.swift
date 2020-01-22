//
//  DayChildVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/14/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

struct Promise {
    let promiseName: String
    let promiseColor: String
}

struct Day {
    var day: String
    var promise: [Promise]
}

class DayChildVC: UIViewController {
    
    @IBOutlet weak var dayTableView: UITableView!
    
    
    var days: [Day] = [
        Day(day: "MON  \n 1", promise: [
            Promise(promiseName: "red", promiseColor: ".red"),
            Promise(promiseName: "yellow", promiseColor: ".yellow"),
        ]),
        Day(day: "TUE  \n 2", promise: [
            Promise(promiseName: "yellow", promiseColor: ".yellow"),
            Promise(promiseName: "black", promiseColor: ".black"),
            Promise(promiseName: "blue", promiseColor: ".blue"),
        ])
        
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        dayTableView.delegate = self
        dayTableView.dataSource = self
    
//        dayTableView.estimatedRowHeight = 1000
//        dayTableView.rowHeight = UITableView.automaticDimension
//        dayTableView.separatorColor = .clear
//        dayTableView.reloadData()
    }

}

extension DayChildVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height:CGFloat = CGFloat(self.days[indexPath.row].promise.count * 40 + 20)
        return height
    }

}

extension DayChildVC: UITableViewDataSource {

//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = dayTableView.dequeueReusableCell(withIdentifier: "DayTVC", for: indexPath) as! DayTVC
        cell.setPromise(day: self.days[indexPath.row])
        return cell
        
//        var cell = UITableViewCell()
//        if let dayCell = dayTableView.dequeueReusableCell(withIdentifier: "DayTVC", for: indexPath) as? DayTVC {
//            cell.backgroundColor = .brown
//            dayCell.setPromise(day: self.days[indexPath.row])
//            cell = dayCell
//        }
//
//        return cell
    }
    
}


//let rowData = self.days[indexPath.row]
                    
//                dayCell.dayLabel.text = rowData.date
//                dayCell.promises = rowData.promiseList

//                print(dayCell.promises)
//                dayCell.updateStackView()
                
//                for (index, element) in rowData.promiseList.enumerated(){
//                    //            print(index)
////                    print(promises[index])
//                    let view = UIView()
//                    let label = UILabel()
//
//                    // 안먹음
//                    view.addSubview(label)
//                    label.text = element.title
//
//                    view.backgroundColor = element.color
//
//                    // 안먹음
//                    var f = view.frame
//                    f.size = CGSize(width: 30, height: 10)
//                    //            view.frame.size.height = CGFloat(10.0)
//                    view.frame = f
////                    print(view.frame.size.width)
////                    print(view.frame.size.height)
//                    dayCell.promiseView.addArrangedSubview(view)
//                    print(dayCell.promiseView.arrangedSubviews[0].frame.size)

//                    dayCell.promiseView.arrangedSubviews[index].widthAnchor.constraint(equalToConstant: dayCell.promiseView.frame.width).isActive = true
//                    dayCell.promiseView.arrangedSubviews[index].heightAnchor.constraint(equalToConstant: 20.0).isActive = true
//                    print(dayCell.promiseView.arrangedSubviews[0].frame.size)
                    
//                }
                
