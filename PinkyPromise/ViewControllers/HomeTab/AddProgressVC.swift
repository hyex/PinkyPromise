//
//  AddProgressVC.swift
//  PinkyPromise
//
//  Created by linc on 2020/02/02.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

protocol SendProgressDelegate {
    func sendProgress(data: Int)
}

class AddProgressVC: UIViewController {
    var promiseId: String!
    var progressId: String!
    var selectedProgress: Int = 0
    
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet var cancelBtn: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var smallView: UIView!
    
    @IBOutlet var bigView: UIView!
    
    var delegate: SendProgressDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.smallView.layer.shadowColor = UIColor.black.cgColor
        self.smallView.layer.masksToBounds = false
        self.smallView.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.smallView.layer.shadowRadius = 8
        self.smallView.layer.shadowOpacity = 0.3
        
        // collectionview delegate & dataSource
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 25
        layout.minimumInteritemSpacing = 25
        collectionView.collectionViewLayout = layout
        cancelBtn.tintColor = UIColor.appColor
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(AddIconVC.dismissPage(sender:)))
        self.bigView.addGestureRecognizer(gesture)
        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
    }

    @objc func dismissPage(sender: UIGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }

    @IBAction func cancelBtnAction(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}

extension AddProgressVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProgressCell", for: indexPath) as! ProgressCVC
        
//        cell.delegate = self
        cell.progressInt = 4 - indexPath.row
        // cell.setProgressLabel()
        
        if cell.progressInt <= selectedProgress {
            cell.setColor(progress: cell.progressInt)
        } else {
            cell.setColor(progress: 0)
        }

        return cell
    }
    
    func collection(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 50)
    }
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! IconCVC
        
        self.selectedProgress = 4 - indexPath.row
        for i in 0...4 {
            let cell = collectionView.cellForItem(at: NSIndexPath(row: 4 - i, section: 0) as! IndexPath)
            //
            // MyApi.shared.addProgressData !!!!@@@ hunjae
            dismiss(animated: false, completion: nil)
        }
    }
}
