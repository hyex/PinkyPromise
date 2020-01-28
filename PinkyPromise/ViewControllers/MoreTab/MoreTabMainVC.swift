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
    
//    var moreTableList = ["내 정보", "나의 약속 친구들", "약속 친구 추가하러가기", "개발자 정보"]

    var moreTableList:[MoreTableData] = [
        MoreTableData(title: "내 정보"),
        MoreTableData(title: "내 친구"),
        MoreTableData(title: "코드로 친구추가")
    ]
    
//    func onComplete(data: [MoreTableData]) -> Void {
//        DispatchQueue.main.async {
//            self.moreTableList = data
//            self.moreTableView.reloadData()
//        }
//    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
//        MyApi.shared.allMore(completion: self.onComplete(data:))
        // 위와 같음
        //    MyApi.shared.allMenu(completion: { result in
        //               DispatchQueue.main.async {
        //                   self.moreTableList = result
        //                   self.moreTableView.reloadData()
        //               }
        //           })

    }
    
}
extension MoreTabMainVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //let selectCell = 
        
        //performSegue(withIdentifier: "detailSegue", sender: self.moreTableList[indexPath.row])
                    
//        moreTableView.backgroundColor = .darkGray
//        print(self.moreTableList[indexPath.row])

        
        //        if let vc = storyboard?.instantiateViewController(withIdentifier: "MoreVC") {
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        }
        
        
        switch indexPath.row {
        case 0:
            print(self.moreTableList[indexPath.row].title)
        case 1:
            print(self.moreTableList[indexPath.row].title)
        case 2:
            let vc = storyboard?.instantiateViewController(identifier: "AddFriendCodeVC") as! AddFriendCodeVC
            
            vc.modalPresentationStyle = .currentContext
            vc.modalTransitionStyle = .coverVertical
            
            self.present(vc, animated: false)
            
        default:
            print("error")
        }
//        performSegue(withIdentifier: "DetailSegue", sender: self.rankingList[indexPath.row])
    

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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection: Int) -> String? {
        return "this is MoreTab"
    }

}

