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
    
    var moreTableList = ["내 정보", "나의 약속 친구들", "약속 친구 추가하러가기", "개발자 정보"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
}
extension MoreTabMainVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let selectCell =
        
        //performSegue(withIdentifier: "detailSegue", sender: self.moreTableList[indexPath.row])
        
        moreTableView.backgroundColor = .darkGray
        print(self.moreTableList[indexPath.row])
        
        //        if let vc = storyboard?.instantiateViewController(withIdentifier: "MoreVC") {
        //            self.navigationController?.pushViewController(vc, animated: true)
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
            
            rankingcell.title.text = rowData
            cell = rankingcell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection: Int) -> String? {
        return "this is MoreTab"
    }
    
}

