//
//  AddColorVC.swift
//  PinkyPromise
//
//  Created by linc on 2020/01/28.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class AddColorVC: UIViewController {

    let colors: [String] = [ "systemIndigo", "systemRed", "systemBlue", "systemGreen", "systemOrange", "systemPurple", "systemTeal", "systemPink" ]
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "ColorCVC", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "ColorCollectionCell")
        
        // collectionview delegate & dataSource
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 25
        layout.minimumInteritemSpacing = 25
        collectionView.collectionViewLayout = layout
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    

}

extension AddColorVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionCell", for: indexPath) as! ColorCVC
        cell.setButtonColor(name: colors[indexPath.row])
        
        return cell
    }

    func collection(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = collectionView.frame.width / 4 - 5
        return CGSize(width: 55, height: 55)
    }
}
