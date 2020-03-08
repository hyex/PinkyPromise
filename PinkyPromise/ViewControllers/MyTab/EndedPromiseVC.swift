//
//  EndedPromiseVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/18/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class EndedPromiseVC: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var endedPromiseCollectionView: UICollectionView!
    
    var promiseList: [PromiseTable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        self.endedPromiseCollectionView.delegate = self
        self.endedPromiseCollectionView.dataSource = self
        
        // getEndedPromise()
    }
    
    // MARK: wantToFix
    override func viewDidAppear(_ animated: Bool) {
        getEndedPromise()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func getEndedPromise() {
        // 날짜가 끝났고, 성취률 100%인 약속들만 넘겨오는 함수
        EndedPromiseService.shared.getCompletedPromiseData(completion: { result in
            DispatchQueue.main.async {
                self.promiseList = result
                self.endedPromiseCollectionView.reloadData()
            }
        })
    }
    
}

// MARK:- Initialization
extension EndedPromiseVC {
    private func initView() {
        backBtn.tintColor = UIColor.appColor
        addSwipeGesture()
    }
    func addSwipeGesture() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        rightSwipe.direction = .right
        endedPromiseCollectionView.addGestureRecognizer(rightSwipe)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .right) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension EndedPromiseVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width - CGFloat(32.0)
//        print(collectionView.bounds.height)
        let height = CGFloat(140.0)//collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
    
}


extension EndedPromiseVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.promiseList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = endedPromiseCollectionView.dequeueReusableCell(withReuseIdentifier: "EndedPromiseCVC", for: indexPath) as! EndedPromiseCVC
        
        let rowData = promiseList[indexPath.row]
        
        cell.promiseFriends.text = "WITH "
        
        if let id = rowData.promiseId {
            EndedPromiseService.shared.getPromiseFriendsNameWithPID(promiseID: id, completion: { result in
                DispatchQueue.main.async {
                    // 친구 3명까지만 이름 노출, 그 외에는 "와 x명"으로 표시
                    for friend in result {
                        cell.promiseFriends.text! += friend + " "
                        if result.count > 3 {
                            if result[2] == friend { //
                                let peoples = result.count - 3
                                cell.promiseFriends.text! += "외 \(String(peoples))명"
                                break
                            }
                        }
                    }
                }
            })
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = rowData.promiseStartTime
        let endDate = rowData.promiseEndTime
        cell.promiseIcon.image = UIImage(named: rowData.promiseIcon)
        cell.promiseName.text = rowData.promiseName

        let duration = dateFormatter.string(from: startDate) + " ~ " + dateFormatter.string(from: endDate)
        cell.promiseDuration.text = duration
        
//        let promiseColor = rowData.promiseColor!
//        cell.backgroundColor = UIColor(named :promiseColor)
//        cell.layer.shadowColor = UIColor(named :promiseColor)?.cgColor
        cell.applyBorder(width: 1.0, color: UIColor.appColor)
        cell.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        cell.layer.shadowColor = UIColor.appColor.cgColor

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

}

