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
        didSet {
            dayTableView.reloadData()
            self.dayTableView.scrollToRow(at: IndexPath(row: 10, section: 0), at: .top, animated: false)
        }
    }
    
    var firstIndex: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMyPageData()
        setUpTableView()
        initRefresh()
//        if let firstIndex = self.firstIndex {
//            print(firstIndex)
//            self.dayTableView.scrollToRow(at: firstIndex, at: .top, animated: false)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getMyPageData()
    }
    
    func initRefresh() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateUI(refresh:)), for: .valueChanged)
        refresh.attributedTitle = NSAttributedString(string: "")
        
        if #available(iOS 10.0, *) {
            dayTableView.refreshControl = refresh
        } else {
            dayTableView.addSubview(refresh)
        }
    }
    
    @objc func updateUI(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        dayTableView.reloadData()
    }

    private func setUpTableView() {
        self.dayTableView.delegate = self
        self.dayTableView.dataSource = self
//        self.dayTableView.rowHeight = UITableView.automaticDimension;
//        self.dayTableView.estimatedRowHeight = 100;
//        self.dayTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    // 통신
    private func getMyPageData() {
        MyApi.shared.getPromiseData10ToNow(completion: { result in
            DispatchQueue.main.async {
                self.dayList = result
                if let firstIndex = self.firstIndex {
                    print(firstIndex)
                    self.dayTableView.scrollToRow(at: firstIndex, at: .top, animated: false)
                }
            }
        })
    }
}

extension DayChildVC: UITableViewDataSource {

    // 1
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dayList = dayList else { return 0 } // nil
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
                firstIndex = indexPath
                // MARK: - NO working
                self.dayTableView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
    //****선영 추가 부분****
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
        if dayList[indexPath.row].promiseData.count == 0 {
            return CGFloat(0.0)
        }
        let height:CGFloat = CGFloat(dayList[indexPath.row].promiseData.count * 43 + 20)
        
        return height
    }
}

  
