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
    
//    fileprivate let promiseHeight: CGFloat = 30
    
    func setPromise(day: Day){
        DispatchQueue.main.async {
            self.dayLabel.text = day.day
            
            if self.promiseView.arrangedSubviews.count != day.promise.count {
                for promise in day.promise {
                    let viewToAdd = OnePromiseView(frame: CGRect.zero, promise: promise)
//                    viewToAdd.backgroundColor = UIColor(named: "blue")
//                    viewToAdd.backgroundColor = UIColor(named: promise.promiseColor)
//                    viewToAdd.backgroundColor = UIColor.blue
//                    print(viewToAdd.backgroundColor)
//                    if promise != nil {
//
//                        let unwrappedPromise = promise
//                        //            let backgroundColor = "UIColor" + unwrappedPromise.promiseColor
////                        print(unwrappedPromise.promiseName)
//                        let selector = Selector("redColor")
//                        //            print("\(unwrappedPromise.promiseName)Color")
//                        if UIColor.self.responds(to: selector) {
//                            let color = UIColor.self.perform(selector).takeUnretainedValue()
//                            //                return (color as! UIColor)
//                            print(color)
//                            viewToAdd.backgroundColor = color as? UIColor
//                        } else {
//                            print("fail")
//                        }
//                        //            print(backgroundColor)
//                    }

                    
//                    print(promise.promiseColor)
//                    print(promise.promiseName)
                    self.promiseView.addArrangedSubview(viewToAdd)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        promiseView.backgroundColor = .lightGray
        dayLabel.makeTwoLine()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
