//
//  MoreTabMainVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/13/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class MoreTabMainVC: UIViewController {

    @IBOutlet weak var moreTableView: UITableView!
    
    var moreTableList:[MoreTableData] = [
        MoreTableData(title: "예제1"),
        MoreTableData(title: "예제2"),
        MoreTableData(title: "예제3"),

    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moreTableView.delegate = self
        moreTableView.dataSource = self
        
    }
    
}


extension MoreTabMainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        rankingTableView.backgroundColor = .darkGray
//        print(self.rankingList[indexPath.row])
//        performSegue(withIdentifier: "DetailSegue", sender: self.rankingList[indexPath.row])
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailVC") {
//            self.navigationController?.pushViewController(vc, animated: false)
//        }
        
    }
}


extension MoreTabMainVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.moreTableList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        if let rankingcell = tableView.dequeueReusableCell(withIdentifier: "MoreTVC", for: indexPath) as? MoreTVC {
//            moreTableList.sort(by: {$0.promiseCount > $1.promiseCount})
            let rowData = self.moreTableList[indexPath.row]
            
            rankingcell.title.text = rowData.title
            cell = rankingcell
        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection: Int) -> String? {
//        return "Ranking"
//    }


}

