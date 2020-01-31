//
//  PromiseChildVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/14/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class PromiseChildVC: UIViewController {

    @IBOutlet weak var endedPromiseBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
//    var promiseList: [PromiseData]? {
    var promiseList: [PromiseTable]? {
        didSet { collectionView.reloadData() }
    }
    
    var progressList: [ProgressTable]? {
        didSet { collectionView.reloadData() }
    }
//    var allProgressList: [eachProgressList]? = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollectionView()
        getAllPromiseData()
        initView()
        
    }
    
    private func setUpCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    // 통신
    private func getAllPromiseData() {
        
        MyApi.shared.getPromiseDataSinceToday(completion: { result in
            DispatchQueue.main.async {
                self.promiseList = result
//                self.collectionView.reloadData()
            }
        })
        
        MyApi.shared.getAllProgressData(completion: { result in
            DispatchQueue.main.async {
                self.progressList = result
            }
        })
        
//        for idx in 0...self.promiseList!.count {
//            MyApi.shared.getProgressData(promiseid: self.promiseList![idx].promiseId, completion: { result in
//                DispatchQueue.main.async {
//                    self.progressList![idx] = result
//                    print(self.progressList)
//                }
//            })
//        }
        
    }
    
    @IBAction func endedPromiseBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "EndedPromiseVC") as! EndedPromiseVC
        
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .overCurrentContext
        
        self.present(vc, animated: false)
    }
    
}

extension PromiseChildVC {
    private func initView() {
        setupBtn()
    }
    
    func setupBtn() {
        
        endedPromiseBtn.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        endedPromiseBtn.layer.cornerRadius = 8.0
        
        endedPromiseBtn.applyShadow(radius: 5.0, color: .gray, offset: CGSize(width: 0.0, height: 1.0), opacity: 1.0)
        endedPromiseBtn.layer.masksToBounds = false
        
        let attributedString = NSAttributedString(string: "100% 지킨 약속 보러가기", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 20.0),
            .foregroundColor: UIColor.appColor //.withAlphaComponent(0.8)
        ])
        endedPromiseBtn.setAttributedTitle(attributedString, for: .normal)
    }
}

extension PromiseChildVC: UICollectionViewDelegateFlowLayout {
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
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
    
    // 선영 추가 부분 --> 클릭 시 실행되는 함수
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 약속 디테일 뷰로 이동해야함. 약속 정보를 가지고
        print(indexPath.row)
        performSegue(withIdentifier: "promiseDetail", sender: Promise(promiseName: "약속이름", promiseColor: "약속 컬러"))
        
    }
    
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

extension PromiseChildVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let promiseList = promiseList else {
            return 1
        }
        return promiseList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var cell = UICollectionViewCell()
        
        if let promiseCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "PromiseCVC", for: indexPath) as? PromiseCVC {
            
            if let list = promiseList {
                
                let rowData = list[indexPath.item]

                var promiseAchievement:Int = 0

                for progress in progressList! {
                    if progress.promiseId == list[indexPath.item].promiseId {
//                        if progress.progressDegree == 4 {
//                            promiseAchievement += 1
//                        }
                    }
                }
                    
                // 날짜만 비교해서 며칠 남았는지 뽑아낸다
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let today = Date()
                let startDate = rowData.promiseStartTime
                let endDate = rowData.promiseEndTime
                
                let interval = endDate.timeIntervalSince(startDate)
                let days = Int(interval / 86400) + 1
                
                let leftInterval = endDate.timeIntervalSince(today)
                let left = Int(leftInterval / 86400) + 1
                
                /** 날짜 차이와 시간 차이까지 알고 싶으면
                 let calendar = Calendar.current
                 let dateGap = calendar.dateComponents([.year,.month,.day,.hour], from: startDate, to: endDate)
                 
                 if case let (y?, m?, d?, h?) = (dateGap.year, dateGap.month, dateGap.day, dateGap.hour)
                 {
                 print("\(y)년 \(m)개월 \(d)일 \(h)시간 후")
                 }
                 */
                
                promiseCell.leftDays.text = "\(left)일남음"
                promiseCell.totalDays.text = String(days)
                
                // slider의 max 값을 변경
                promiseCell.appSlider.maximumValue = Float(days)
                
                promiseCell.promiseIcon.image = UIImage(named: rowData.promiseIcon)
                promiseCell.promiseName.text = rowData.promiseName
                promiseCell.appSlider.value = Float(promiseAchievement)
                promiseCell.showSliderValue.text = String(promiseAchievement)
                
                let sliderValueOriginX = promiseCell.showSliderValue.layer.position.x
                let sliderValueOriginY = promiseCell.showSliderValue.layer.position.y
                let calcValue = CGFloat( Float(promiseAchievement) / promiseCell.appSlider.maximumValue * Float(promiseCell.appSlider.frame.width))
                
                promiseCell.showSliderValue.layer.position.x = sliderValueOriginX + calcValue //- CGFloat(2.0)
                promiseCell.showSliderValue.layer.position.y = sliderValueOriginY

            }
            cell = promiseCell
        }
        return cell
    }

}
        
