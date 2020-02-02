//
//  AddProgressVC.swift
//  PinkyPromise
//
//  Created by linc on 2020/02/02.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class AddProgressVC: UIViewController {
    
    var selectedProgress: Int = 0
    
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet var cancelBtn: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var smallView: UIView!
    
    @IBOutlet var bigView: UIView!
    
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProgressCell", for: indexPath)
 
        if indexPath.row == selectedProgress {
            cell.progress
            cell.setSelectedBox()
        }
        cell.setButtonIcon(name: icons[indexPath.row])
        
        return cell
    }
    
    func collection(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 50)
    }
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! IconCVC
        cell.layer.borderColor = UIColor.gray.cgColor
        
        //        cell.getButtonColor()
        
    }
}
