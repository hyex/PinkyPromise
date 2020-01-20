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
    
    let promiseList: [PromiseData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.tintColor = .black
//        self.endedPromiseCollectionView.delegate = self
//        self.endedPromiseCollectionView.dataSource = self
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    

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
