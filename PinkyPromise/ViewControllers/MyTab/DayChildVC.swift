//
//  DayChildVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/14/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class DayChildVC: UIViewController {

    @IBOutlet weak var dayCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayCollectionView.delegate = self
        dayCollectionView.dataSource = self

    }

}

extension DayChildVC: UICollectionViewDelegate {
    
}

extension DayChildVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if let dayCell = dayCollectionView.dequeueReusableCell(withReuseIdentifier: "DayCVC", for: indexPath) as? DayCVC {
            //            moreTableList.sort(by: {$0.promiseCount > $1.promiseCount})
            //                    let rowData = self.moreTableList[indexPath.row]
            
            cell = dayCell
        }
        
        return cell
    }
    
}

extension DayChildVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = 375
//        let height =
        let width = dayCollectionView.bounds.width
        
        /**
         MARK: 이 높이를 테이블뷰의 크기에 맞추어서 하는 게 목표
         */
        let height = dayCollectionView.bounds.height/3
        return CGSize(width: width, height: height)
    }
}


