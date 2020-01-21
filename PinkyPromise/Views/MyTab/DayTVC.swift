//
//  DayTVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/14/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class DayTVC: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var promiseView: UIStackView!
    
    fileprivate let promiseHeight: CGFloat = 30
    
    func setPromise(day: Day){
        DispatchQueue.main.async {
            self.dayLabel.text = day.day
            
            if self.promiseView.arrangedSubviews.count != day.promise.count {
                for promise in day.promise {
                    let viewToAdd = OnePromiseView(frame: CGRect.zero, promise: promise)
//                    viewToAdd.backgroundColor = UIColor(named: "blue")
//                    viewToAdd.backgroundColor = UIColor(named: promise.promiseColor)
//                    print(promise.promiseColor)
//                    print(promise.promiseName)
                    self.promiseView.addArrangedSubview(viewToAdd)
                }
            }
        }
    }
//
//    func updateStackView() {
//        for (index, element) in promises.enumerated(){
////            print(index)
//            print(promises[index])
//            let view = UIView()
//            let label = UILabel()
//
//            // 안먹음
//            view.addSubview(label)
//            label.text = element.title
//
//            view.backgroundColor = element.color
//
//            // 안먹음
//            var f = view.frame
//            f.size = CGSize(width: 30, height: 10)
////            view.frame.size.height = CGFloat(10.0)
//            view.frame = f
//
//            self.promiseView.addArrangedSubview(view)
//        }
//        self.setNeedsLayout()
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        promiseView.backgroundColor = .lightGray
        dayLabel.makeTwoLine()
//        print("awake")
        
//        for (index, element) in promises.enumerated(){
//            print(index)
//            let view = UIView()
//            let label = UILabel()
//
//            label.text = element.title
//            view.addSubview(label)
//            view.backgroundColor = element.color
//            var f = view.frame
//            f.size = CGSize(width: 300, height: 20)
//            view.frame = f
//            self.promiseView.addArrangedSubview(view)
//        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
