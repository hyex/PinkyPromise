//
//  endedPromiseVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/18/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class endedPromiseVC: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var endedPromiseCollectionView: UICollectionView!
    
    let promiseList: [MyPromise] = [MyPromise(promiseName: "1시간 독서", promiseStory: "1시간 독서하기", pormiseProgress: 3.0),
                                 MyPromise(promiseName: "2시간 운동", promiseStory: "2시간 운동하기", pormiseProgress: 2.4),
                                 MyPromise(promiseName: "2시간 동방", promiseStory: "2시간 누워있기", pormiseProgress: 2.4),
                                 MyPromise(promiseName: "2시간 공부", promiseStory: "2시간 공부하기", pormiseProgress: 5.4),
                                 MyPromise(promiseName: "2시간 식사", promiseStory: "2시간 식사하기", pormiseProgress: 8.0),
                                 MyPromise(promiseName: "2시간 취침", promiseStory: "2시간 취침하기", pormiseProgress: 9.4),
                                 MyPromise(promiseName: "2시간 기상", promiseStory: "2시간 기상하기", pormiseProgress: 3.4),
                                 MyPromise(promiseName: "2시간 체조", promiseStory: "2시간 체조하기", pormiseProgress: 1.8)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.tintColor = .black
//        self.endedPromiseCollectionView.delegate = self
//        self.endedPromiseCollectionView.dataSource = self
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


//extension endedPromiseVC: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = UICollectionViewCell()
//        return cell
//    }
//
//
//}
