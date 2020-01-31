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
    var friendList: [PromiseUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        self.endedPromiseCollectionView.delegate = self
        self.endedPromiseCollectionView.dataSource = self
        
        // 날짜가 끝났고, 성취률 100%인 약속들만 넘겨오는 함수 만들기 Api 에서
        MyApi.shared.getCompletedPromiseData(completion: { result in
            DispatchQueue.main.async {
                self.promiseList = result
                print(result)
                self.endedPromiseCollectionView.reloadData()
            }
        })
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    

}


extension EndedPromiseVC {
    private func initView() {
        backBtn.tintColor = .black
        addSwipeGesture()
    }
    func addSwipeGesture() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        rightSwipe.direction = .right
        endedPromiseCollectionView.addGestureRecognizer(rightSwipe)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .right) {
            self.dismiss(animated: false, completion: nil)}
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
        let height = CGFloat(140.0)//collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
    
}


extension EndedPromiseVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        guard let promiseList = promiseList else {
//            return 1
        //        }
        return self.promiseList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = endedPromiseCollectionView.dequeueReusableCell(withReuseIdentifier: "EndedPromiseCVC", for: indexPath) as! EndedPromiseCVC
        
        let rowData = promiseList[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //        let today = Date()
        let startDate = rowData.promiseStartTime
        let endDate = rowData.promiseEndTime
        
        //        cell.promiseIcon = rowData.promiseIcon
        cell.promiseName.text = rowData.promiseName

        let duration = dateFormatter.string(from: startDate) + " ~ " + dateFormatter.string(from: endDate)
        cell.promiseDuration.text = duration
        
        let promiseColor = rowData.promiseColor!

        cell.backgroundColor = UIColor(named :promiseColor)
        cell.layer.shadowColor = UIColor(named :promiseColor)?.cgColor

        
        return cell
    }

    // 선영 추가 부분 --> 클릭 시 실행되는 함수
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 약속 디테일 뷰로 이동해야함. 약속 정보를 가지고
        print(indexPath.row)
//        performSegue(withIdentifier: "promiseDetail", sender: Promise(promiseName: "약속이름", promiseColor: "약속 컬러"))
        performSegue(withIdentifier: "promiseDetail", sender: promiseList[indexPath.row])
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("in prepare func")
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

