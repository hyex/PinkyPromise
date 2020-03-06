//
//  FriendTabMainVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/13/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

struct PromiseWithFriend {
    var userimg : String
    var promiseId : String
    var promiseName : String
    var friendsName : [String]
}

import UIKit

class FriendTabMainVC: UIViewController {
    
    @IBOutlet weak var addNewPromiseBtn: UIButton!
    @IBOutlet weak var promiseCtnLabel: UILabel!
    @IBOutlet weak var friendMainTableView: UITableView!
    
    var PromiseList : [PromiseWithFriend] = []{
        didSet {friendMainTableView.reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPlusBtn()
        getPromiseAndFriend()
        setUpTableView()
    }
    
    func setUpTableView() {
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
    
    private func getPromiseAndFriend() {
        FriendTabMainService.shared.getPromiseNameAndFriendsName { (result) in
            for douc in result {
                self.PromiseList.append(PromiseWithFriend(userimg : douc.FirstuserImage, promiseId: douc.promiseId, promiseName: douc.promiseName, friendsName: douc.friendsName))
            }
        }
    }
}

extension FriendTabMainVC : UITableViewDelegate{
    //table segue 설정, modal 스타일 설정
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "FriendTabDetailVC") as! FriendTabDetailVC
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .overCurrentContext
        vc.detailPromise = self.PromiseList[indexPath.row]
        
        self.present(vc, animated: false) {
            vc.detailPromise = self.PromiseList[indexPath.row]
        }
    }
}

extension FriendTabMainVC : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.PromiseList.count
    }
    
    //table view cell 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as! FriendTableViewCell
        
        let promiseData = self.PromiseList[indexPath.row]
        
        promiseCtnLabel.text = String(PromiseList.count)
        cell.friendProfileImg.layer.cornerRadius = cell.friendProfileImg.frame.width/2
        cell.friendProfileImg.clipsToBounds = true
        
        //사용자 프사가 default image 이면
        if (promiseData.userimg == "userDefaultImage") {
            cell.friendProfileImg.image = UIImage(named: "userDefaultImage")
        }else{
            //이미지 수정
            FirebaseStorageService.shared.getUserImageURLWithName(name: promiseData.userimg, completion: { imgResult in
                switch imgResult {
                case .failure(let err):
                    print(err)
                    cell.friendProfileImg.image = UIImage(named: "userDefaultImage")
                case .success(let url):
                    let imgURL = URL(string: url)
                    do{
                        let data = try Data(contentsOf: imgURL!)
                        cell.friendProfileImg.image = UIImage(data: data)
                    } catch{
                        print("get img url failed")
                        cell.friendProfileImg.image = UIImage(named: "userDefaultImage")
                    }
                }
            })
        }
        
        if (promiseData.friendsName.count == 1) {
            cell.friendNameLabel.text = promiseData.friendsName[0]
        }else{
            cell.friendNameLabel.text = promiseData.friendsName[0] + " 외 \(promiseData.friendsName.count - 1)명"
        }
        cell.promiseNameLabel.text = promiseData.promiseName
        
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
            let promise = sender as? PromiseWithFriend
            if promise != nil{
                let FriendTabDetailVC = segue.destination as? FriendTabDetailVC
                if FriendTabDetailVC != nil {
                    FriendTabDetailVC?.detailPromise = promise
                }
            }
        }
    }
}
