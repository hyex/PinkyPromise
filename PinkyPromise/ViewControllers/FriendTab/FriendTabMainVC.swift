//
//  FriendTabMainVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/13/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

struct FriendsInfo {
    var img : String
    var friendname : String
    var promisename : String
}

import UIKit

class FriendTabMainVC: UIViewController {
    
    @IBOutlet weak var addNewPromiseBtn: UIButton!
    @IBOutlet weak var promiseCtnLabel: UILabel!
    @IBOutlet weak var friendMainTableView: UITableView!
    
    //임시 친구약속 데이터
    let friendsInPromise : [FriendsInfo] = [
    FriendsInfo(img: "seonyoung", friendname: "sunnyangee", promisename: "매일 성북천 3K 조깅"),
    FriendsInfo(img: "heji", friendname: "hyex", promisename: "물 하루 1L 이상 마시기 "),
    FriendsInfo(img: "hyunjae", friendname: "hyunJae", promisename: "2시 전 취침 10시 전 기상"),
    FriendsInfo(img: "uijeong", friendname: "jeongUijeong", promisename: "One day One commit"),
    FriendsInfo(img: "seonyoung", friendname: "sunnyangee", promisename: "매일 성북천 3K 조깅"),
    FriendsInfo(img: "heji", friendname: "hyex", promisename: "물 하루 1L 이상 마시기 "),
    FriendsInfo(img: "hyunjae", friendname: "hyunJae", promisename: "2시 전 취침 10시 전 기상"),
    FriendsInfo(img: "uijeong", friendname: "jeongUijeong", promisename: "One day One commit")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.isHidden = true
        getAllPromiseData()
        setPlusBtn()
        
        friendMainTableView.delegate = self
        friendMainTableView.dataSource = self
        friendMainTableView.tableFooterView = UIView()
        
    }
    
    //약속 추가 버튼 이미지 설정
    func setPlusBtn() {
        let purplePlus : UIImage = UIImage(named: "plus")!
        addNewPromiseBtn.setImage(purplePlus, for: UIControl.State.normal)
    }

    //약속 추가 버튼 액션
    @IBAction func addPromiseBtnAction(_ sender: Any) {
        let homeTabStoryboard = UIStoryboard(name: "HomeTab", bundle: nil)
        let vc = homeTabStoryboard.instantiateViewController(withIdentifier: "HomeNavigationController") as! HomeNavigationController
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .overCurrentContext
        
        self.present(vc, animated: false, completion: nil)
    }
    
    //나의 모든 약속 데이터 가져오기
    private func getAllPromiseData() {
        print("in get AllPromiseData func")
        MyApi.shared.allPromise { result in DispatchQueue.main.async {
            print("**********promise data from db**********")
            print("첫 데이터 : ", result[0])
            }
        }
    }
}

extension FriendTabMainVC : UITableViewDelegate{
    //table segue 설정, modal 스타일 설정
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "detailPromise", sender: self.friendsInPromise[indexPath.row])
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "FriendTabDetailVC") as! FriendTabDetailVC
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .overCurrentContext
        
        
        self.present(vc, animated: false) {
            vc.detailPromise = self.friendsInPromise[indexPath.row]
        }
    }
}

extension FriendTabMainVC : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return self.friendsInPromise.count
    }
    
    //table view cell 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as! FriendTableViewCell
        
        let rowData = self.friendsInPromise[indexPath.row]
        
        cell.friendProfileImg.layer.cornerRadius = cell.friendProfileImg.frame.width/2
        cell.friendProfileImg.clipsToBounds = true
        
        cell.friendProfileImg.image = UIImage(named: rowData.img)
        cell.friendNameLabel.text = rowData.friendname
        cell.promiseNameLabel.text = rowData.promisename

        let purpleArrow : UIImage = UIImage(named: "next")!
        cell.friendDatailBtn.setImage(purpleArrow, for: UIControl.State.normal)

        return cell
    }
    
    //tableview cell 높이 수정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    //segue 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailPromise" {
            let promise = sender as? FriendsInfo
            if promise != nil{
                let FriendTabDetailVC = segue.destination as? FriendTabDetailVC
                if FriendTabDetailVC != nil {
                    FriendTabDetailVC?.detailPromise = promise
                }
            }
        }
    }
}
