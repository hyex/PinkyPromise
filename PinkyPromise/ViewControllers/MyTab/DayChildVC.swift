//
//  DayChildVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/14/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class DayChildVC: UIViewController {
    
    @IBOutlet weak var dayTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayTableView.delegate = self
        dayTableView.dataSource = self

    }

}

extension DayChildVC: UITableViewDelegate {
    
}

extension DayChildVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
            if let dayCell = dayTableView.dequeueReusableCell(withIdentifier: "DayTVC", for: indexPath) as? DayTVC {
        
                cell = dayCell
            }
        
            return cell
    }
    
    
    
}

