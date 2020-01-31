//
//  AddIconVC.swift
//  PinkyPromise
//
//  Created by linc on 2020/01/28.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

protocol SelectedIconDelegate {
    func backSelectedIcon(data: String, num: Int)
}

protocol SendSelectedIconDelegate {
    func sendSelectedIcon(data: String, num: Int)
}

class AddIconVC: UIViewController {
    
    var selectedIcon: Int = 0
    
    let icons: [String] = [ "star", "timer", "gym", "weight-scale", "sleep", "list", "ebook", "award", "family",  "couple",  "no-smoking", "beer" ]
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var smallView: UIView!
    
    @IBOutlet var bigView: UIView!
    
    var delegate: SendSelectedIconDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "IconCVC", bundle: nil)
        
        self.smallView.layer.shadowColor = UIColor.black.cgColor
        self.smallView.layer.masksToBounds = false
        self.smallView.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.smallView.layer.shadowRadius = 8
        self.smallView.layer.shadowOpacity = 0.3
        
        collectionView.register(nibName, forCellWithReuseIdentifier: "IconCollectionCell")
        
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
    }
    
    @objc func dismissPage(sender: UIGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}
extension AddIconVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconCollectionCell", for: indexPath) as! IconCVC
        cell.delegate = self
        if indexPath.row == selectedIcon {
            cell.setSelectedBox()
        }
        cell.setButtonIcon(name: icons[indexPath.row])
        
        return cell
    }
    
    func collection(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        let width = collectionView.frame.width / 4 - 5
        return CGSize(width: 55, height: 55)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! IconCVC
        cell.layer.borderColor = UIColor.gray.cgColor
        
        //        cell.getButtonColor()
        
    }
}

extension AddIconVC: SelectedIconDelegate {
    func backSelectedIcon(data: String, num: Int) {
        let cell = collectionView.cellForItem(at: IndexPath(row: selectedIcon, section: 0)) as! IconCVC
        cell.dismissSelectedBox()
        
        delegate.sendSelectedIcon(data: data, num: num)
        dismiss(animated: true, completion: nil)
    }
}
