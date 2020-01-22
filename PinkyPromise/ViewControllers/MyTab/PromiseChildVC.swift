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
    
    var promiseList: [PromiseData] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        MyApi.shared.allPromise(completion: { result in
            DispatchQueue.main.async {
                self.promiseList = result
                self.collectionView.reloadData()
            }
        })
    }
    
    
    @IBAction func endedPromiseBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "endedPromiseVC") as! endedPromiseVC
        
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
        
        endedPromiseBtn.layer.borderColor = UIColor.clear.cgColor
        endedPromiseBtn.layer.borderWidth = 1.0
        endedPromiseBtn.backgroundColor = .white
        endedPromiseBtn.layer.cornerRadius = 8
        endedPromiseBtn.layer.masksToBounds = false
        
        endedPromiseBtn.layer.shadowColor = UIColor.gray.cgColor
        endedPromiseBtn.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        endedPromiseBtn.layer.shadowRadius = 5
        endedPromiseBtn.layer.shadowOpacity = 1.0
        
        let appColor = UIColor(displayP3Red: 142.0/255.0, green: 128.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        let attributedString = NSAttributedString(string: "100% 지킨 약속 보러가기", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 20.0),
          .foregroundColor: appColor
        ])

        endedPromiseBtn.setAttributedTitle(attributedString, for: .normal )
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
            let width = 300
            let height = 100
    //        let width = timelineCollectionView.bounds.width
    //        let height = timelineCollectionView.bounds.height
            return CGSize(width: width, height: height)
        }
}




extension PromiseChildVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.promiseList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromiseCVC", for: indexPath) as! PromiseCVC

        let  rowData: PromiseData = self.promiseList[indexPath.item]
        
        print(rowData.promiseStartTime)
        print(rowData.promiseEndTime)
        
        // 날짜만 비교해서 며칠 남았는지 뽑아낸다
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = Date()
        let startDate = rowData.promiseStartTime
        let endDate = rowData.promiseEndTime

        let interval = endDate.timeIntervalSince(startDate)
        let days = Int(interval / 86400)
        
        let leftInterval = endDate.timeIntervalSince(today)
        let left = Int(leftInterval / 86400)

        /** 날짜 차이와 시간 차이까지 알고 싶으면
         let calendar = Calendar.current
         let dateGap = calendar.dateComponents([.year,.month,.day,.hour], from: startDate, to: endDate)

         if case let (y?, m?, d?, h?) = (dateGap.year, dateGap.month, dateGap.day, dateGap.hour)
         {
           print("\(y)년 \(m)개월 \(d)일 \(h)시간 후")
         }
         */
        
        cell.leftDays.text = "\(left)일남음"
        cell.totalDays.text = String(days)
        
        // slider의 max 값을 변경
        cell.appSlider.maximumValue = Float(days)
//        print(cell.appSlider.maximumValue)
        
        

        cell.promiseName.text = rowData.promiseName
        cell.appSlider.value = Float( rowData.promiseAchievement)
        cell.showSliderValue.text = String( rowData.promiseAchievement)

        let sliderValueOriginX = cell.showSliderValue.layer.position.x
        let calcValue = CGFloat( Float(rowData.promiseAchievement) / cell.appSlider.maximumValue * Float(cell.appSlider.frame.width))
        
        cell.showSliderValue.layer.position.x = sliderValueOriginX + calcValue - CGFloat(2.0)
        
        cell.setNeedsLayout()
        
        return cell

    }
    
}


   /**
    let dateFormatter = DateFormatter()
    //    dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
    
    dateFormatter.date(from:"2020-01-03 10:00"),
    */
