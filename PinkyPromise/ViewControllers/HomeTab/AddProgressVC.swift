//
//  AddProgressVC.swift
//  PinkyPromise
//
//  Created by linc on 2020/02/02.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit
import Foundation

protocol SendProgressDelegate {
    func sendProgress(data: Int)
}

protocol SelectedProgressDelegate {
    func backSelectedProgress(num: Int)
}


class AddProgressVC: UIViewController {
    var promiseId: String!
    var progressId: String!
    var selectedProgress: Int = -1
    var day: Date!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet var cancelBtn: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var smallView: UIView!
    
    @IBOutlet var bigView: UIView!
    
    var delegate: SendProgressDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "ProgressCVC", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "ProgressCell")
        
        self.smallView.layer.shadowColor = UIColor.black.cgColor
        self.smallView.layer.masksToBounds = false
        self.smallView.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.smallView.layer.shadowRadius = 8
        self.smallView.layer.shadowOpacity = 0.3
        
        // collectionview delegate & dataSource
        collectionView.delegate = self
        collectionView.dataSource = self
        
        cancelBtn.tintColor = UIColor.appColor
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(AddProgressVC.dismissPage(sender:)))
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
    
    @IBAction func saveBtnAction(_ sender: Any) {
        var promiseTable: PromiseTable!
        var progressTable: ProgressTable!
        
        let queue = DispatchQueue(label: "queue")
        let myGroup = DispatchGroup()
        
        myGroup.enter()
        AddProgressService.shared.getPromiseDataWithPromiseId(promiseid: promiseId) { (result) in
            queue.async(group: myGroup){
                promiseTable = result[0]
                myGroup.leave()
            }
        }
            
        myGroup.enter()
        AddProgressService.shared.getProgressDataWithPromiseId(promiseid: promiseId) { (result) in
            queue.async(group: myGroup) {
                progressTable = result[0]
                myGroup.leave()
            }
        }

        myGroup.notify(queue: queue) {
            AddProgressService.shared.updateProgress(day: self.day, userId: FirebaseUserService.currentUserID!, data: self.selectedProgress, promise: promiseTable, progress: progressTable)
        }

        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: nil)
        }
    }
}

extension AddProgressVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProgressCell", for: indexPath) as! ProgressCVC

        cell.delegate = self
        
        cell.progressInt = 4 - indexPath.row
        
        cell.setProgressLabel(progress: 4 - indexPath.row)
        
        if selectedProgress == -1 {
            cell.setColor(progress: -1)
        } else if cell.progressInt <= selectedProgress {
            cell.setColor(progress: cell.progressInt)
        } else {
            cell.setColor(progress: -1)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 120
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
        
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedProgress = 4 - indexPath.row
        for i in 0...4 {
            let cell = collectionView.cellForItem(at: NSIndexPath(row: 4 - i, section: 0) as IndexPath) as! ProgressCVC
            
            if selectedProgress == -1 {
                cell.setColor(progress: -1)
            } else if cell.progressInt <= selectedProgress {
                cell.setColor(progress: cell.progressInt)
            } else {
                cell.setColor(progress: -1)
            }
        }
    }
}

extension AddProgressVC: SelectedProgressDelegate {
    func backSelectedProgress(num: Int) {
        self.selectedProgress = num
        for i in 0...4 {
            let cell = collectionView.cellForItem(at: NSIndexPath(row: 4 - i, section: 0) as IndexPath) as! ProgressCVC
            
            if selectedProgress == -1 {
                cell.setColor(progress: -1)
            } else if cell.progressInt <= selectedProgress {
                cell.setColor(progress: cell.progressInt)
            } else {
                cell.setColor(progress: -1)
            }
        }
    }
}
