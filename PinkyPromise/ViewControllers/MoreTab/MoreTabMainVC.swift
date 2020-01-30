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
        MoreTableData(title: "내 정보"),
        MoreTableData(title: "내 친구"),
        MoreTableData(title: "코드로 친구추가")
//        MoreTableData(title: "개발자")
    ]
    
//    func onComplete(data: [MoreTableData]) -> Void {
//        DispatchQueue.main.async {
//            self.moreTableList = data
//            self.moreTableView.reloadData()
//        }
//    }
//     사용시
//    MyApi.shared.allMore(completion: self.onComplete(data:))

    override func viewDidLoad() {
        super.viewDidLoad()
        moreTableView.delegate = self
        moreTableView.dataSource = self
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
}
extension MoreTabMainVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.row {
        case 0:
            let vc = storyboard?.instantiateViewController(identifier: "MyPageVC") as! MyPageVC
            self.navigationController?.pushViewController(vc, animated: false)
        case 1:
            let vc = storyboard?.instantiateViewController(identifier: "MyFriendVC") as! MyFriendVC
            self.navigationController?.pushViewController(vc, animated: false)
        case 2:
            let vc = storyboard?.instantiateViewController(identifier: "AddFriendCodeVC") as! AddFriendCodeVC
            self.navigationController?.pushViewController(vc, animated: false)
//        case 3:
//            print(self.moreTableList[indexPath.row].title)
        default:
            print("MoreTab moving error")
        }
    }
}

extension MoreTabMainVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.moreTableList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        if let rankingcell = tableView.dequeueReusableCell(withIdentifier: "MoreTVC", for: indexPath) as? MoreTVC {

            let rowData = self.moreTableList[indexPath.row]
            rankingcell.title.text = rowData.title
            cell = rankingcell
        }
        
        return cell
    }

}

