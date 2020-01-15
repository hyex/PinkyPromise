//
//  PromiseChildVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/14/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class PromiseChildVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let promises: [MyPromise] = [MyPromise(promiseName: "1시간 독서", promiseStory: "1시간 독서하기", pormiseProgress: 3.0),
                                 MyPromise(promiseName: "2시간 운동", promiseStory: "2시간 운동하기", pormiseProgress: 2.4),
                                 MyPromise(promiseName: "2시간 동방", promiseStory: "2시간 누워있기", pormiseProgress: 2.4),
                                 MyPromise(promiseName: "2시간 공부", promiseStory: "2시간 공부하기", pormiseProgress: 5.4),
                                 MyPromise(promiseName: "2시간 식가", promiseStory: "2시간 식사하기", pormiseProgress: 8.0),
                                 MyPromise(promiseName: "2시간 취침", promiseStory: "2시간 취침하기", pormiseProgress: 9.4),
                                 MyPromise(promiseName: "2시간 기상", promiseStory: "2시간 기상하기", pormiseProgress: 3.4),
                                 MyPromise(promiseName: "2시간 체조", promiseStory: "2시간 체조하기", pormiseProgress: 1.8)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.reloadData()
        
    }
}

extension PromiseChildVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 16
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
        
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = 300
            let height = 70
    //        let width = timelineCollectionView.bounds.width
    //        let height = timelineCollectionView.bounds.height
            return CGSize(width: width, height: height)
        }
}




extension PromiseChildVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.promises.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromiseCVC", for: indexPath) as! PromiseCVC

        let tempPromise: MyPromise = self.promises[indexPath.item]

        //cell.backgroundColor = UIColor(named: "LightBlue")

        cell.promiseName.text = tempPromise.promiseName
        cell.appSlider.minimumTrackTintColor = UIColor(named: "Red")
        cell.appSlider.maximumTrackTintColor = UIColor(named: "DarkRed")
        cell.appSlider.thumbTintColor = UIColor(named: "Red")
        //cell.appSlider.setThumbImage( UIImage(named: "Circle"), for: .normal)

        cell.appSlider.value = 5

        cell.setNeedsLayout()

        return cell

    }
    
}
