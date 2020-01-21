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
        day(date: "MON  \n 1", promiseList: [
            promise(color: .red, title: "red"),
            promise(color: .yellow, title: "yellow"),
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
        dayTableView.estimatedRowHeight = 1000
        dayTableView.rowHeight = UITableView.automaticDimension
        dayTableView.separatorColor = .clear
        dayTableView.reloadData()
    }

}

extension DayChildVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension;
    }
}

extension DayChildVC: UITableViewDataSource {

//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
            if let dayCell = dayTableView.dequeueReusableCell(withIdentifier: "DayTVC", for: indexPath) as? DayTVC {
                
                let rowData = self.dayList[indexPath.row]
                
                dayCell.dayLabel.text = rowData.date
                
//                print("1")
                dayCell.promises = rowData.promiseList
                
//                print(dayCell.promises)
//                dayCell.updateStackView()
                
                for (index, element) in rowData.promiseList.enumerated(){
                    //            print(index)
//                    print(promises[index])
                    let view = UIView()
                    let label = UILabel()
                    
                    // 안먹음
                    view.addSubview(label)
                    label.text = element.title
                    
                    view.backgroundColor = element.color
                    
                    // 안먹음
                    var f = view.frame
                    f.size = CGSize(width: 30, height: 10)
                    //            view.frame.size.height = CGFloat(10.0)
                    view.frame = f
//                    print(view.frame.size.width)
//                    print(view.frame.size.height)
                    dayCell.promiseView.addArrangedSubview(view)
//                    print(dayCell.promiseView.arrangedSubviews[0].frame.size)
                    
//                    dayCell.promiseView.arrangedSubviews[index].widthAnchor.constraint(equalToConstant: dayCell.promiseView.frame.width).isActive = true
//                    dayCell.promiseView.arrangedSubviews[index].heightAnchor.constraint(equalToConstant: 20.0).isActive = true
//                    print(dayCell.promiseView.arrangedSubviews[0].frame.size)
                    
                }
                

                cell = dayCell
            }
        
            return cell
    }
    
}


