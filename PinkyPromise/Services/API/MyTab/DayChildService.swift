//
//  DayChildService.swift
//  PinkyPromise
//
//  Created by SEONYOUNG LEE on 2020/02/25.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

class DayChildService : NSObject {
    
    static let shared = DayChildService()
    
    fileprivate let promiseCollectionRef = Firestore.firestore().collection(PROMISETABLEREF)
    
    func getPromiseData30ToNow(completion: @escaping ([PromiseWithDay]) -> Void ) {
    
        let now3 = Date(timeIntervalSince1970: ceil( Date().timeIntervalSince1970/86400)*86400 + 21600 - (15*3600))
        
        promiseCollectionRef.whereField(PROMISEUSERS, arrayContains: FirebaseUserService.currentUserID!).order(by: PROMISEENDTIME).getDocuments { (snapShot, error) in
            if let err = error {
                debugPrint(err.localizedDescription)
            } else {
                let tempResult = PromiseTable.parseData(snapShot: snapShot)
                var temp1 = [PromiseWithDay]()
                
                //30일 전부터 30일 후까지
                for i in stride(from: now3.timeIntervalSince1970 - (2592000 * 3), through: now3.timeIntervalSince1970 + (2592000 * 3), by: 86400) {
                    var temp2 = [PromiseTable]()
                    
                    for douc in tempResult {
                        if (i >= douc.promiseStartTime.timeIntervalSince1970) && (i <= douc.promiseEndTime.timeIntervalSince1970) {
                            temp2.append(douc)
                        }
                    }
                    
                    let temp3 = PromiseWithDay(Day: Date(timeIntervalSince1970: i + 21600 - (15 * 3600)), promiseData: temp2)
                    temp1.append(temp3)
                }
                completion(temp1)
            }
        }
    }
    
    
}
