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
    var day: Int
    var promise: [Promise]
}

class DayChildVC: UIViewController {
    
    @IBOutlet weak var dayTableView: UITableView!
    
    var days: [Day] = [
        Day(day: 0, promise: [
            Promise(promiseName: "red", promiseColor: "red"),
            Promise(promiseName: "yellow", promiseColor: "yellow")
        ]),
        Day(day: 1, promise: [
            Promise(promiseName: "yellow", promiseColor: "yellow"),
            Promise(promiseName: "green", promiseColor: "green"),
            Promise(promiseName: "blue", promiseColor: "blue"),
            Promise(promiseName: "purple", promiseColor: "purple"),
            Promise(promiseName: "blue", promiseColor: "blue"),
            Promise(promiseName: "green", promiseColor: "green"),
            Promise(promiseName: "systemPink", promiseColor: "systemPink")
        ]),
        Day(day: 2, promise: [
            Promise(promiseName: "purple", promiseColor: "purple"),
            Promise(promiseName: "green", promiseColor: "green"),
            Promise(promiseName: "systemPink", promiseColor: "systemPink")
        ])
    ]

    var promiseList: [PromiseTable]? {
        didSet { dayTableView.reloadData() }
    }
    
    var dayList: [DayAndPromise]? {
        didSet { dayTableView.reloadData()
//            print(dayList!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMyPageData()
//        initView()
        setUpTableView()
    }

    private func setUpTableView() {
        self.dayTableView.delegate = self
        self.dayTableView.dataSource = self
    }
    
    // 통신
    // Day 별 
    private func getMyPageData() {
        MyApi.shared.getPromiseData10ToNow(completion: { result in
            DispatchQueue.main.async {
                self.dayList = result
            }
        })
    }
}

//extension DayChildVC {
//    func initView() {
////        addSwipeGesture()
//    }
//
//
//}

extension DayChildVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let dayList = dayList else { return 0 }
//        return dayList.count
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = dayTableView.dequeueReusableCell(withIdentifier: "DayTVC", for: indexPath) as! DayTVC
        cell.vc = self
        
//        if let list = self.dayList {
//            let rowData = list[indexPath.row]
//            cell.setPromise(day: rowData)
//        }
        
//        if let list = self.promiseList {
//            let rowData = list[indexPath.row]
//        }
        
        cell.setPromise(day: self.days[indexPath.row])
        return cell
    }
    
    //****선영 추가 부분****
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("in prepare func")
        if segue.identifier == "promiseDetail"{
            let promiseDetail = sender as? Promise
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
//        guard let dayList = dayList else { return 0 }
//        let height:CGFloat = CGFloat(dayList[indexPath.row].promiseData.count * 40 + 10)
        let height:CGFloat = CGFloat(self.days[indexPath.row].promise.count * 40 + 10)
        return height
        
    }
    
}

  
