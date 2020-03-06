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
    fileprivate let userCollectionRef = Firestore.firestore().collection(PROMISEUSERREF)
    fileprivate let progressCollectionRef = Firestore.firestore().collection(PROGRESSTABLEREF)
    
    var promiseListner: ListenerRegistration!
    
    let dateFormatter = DateFormatter()
    
    // MARK: Q
    //오늘을 기준으로 10일 이전 약속들을 [PromiseTable]을 하나의 배열 요소로 가지는 배열
    func getPromiseData10ToNow(completion: @escaping ([DayAndPromise]) -> Void ) {
        
        let now = Date()
        let now2 = Timestamp()
        let now3 = now2.dateValue() + 36000
        
        promiseCollectionRef.whereField(PROMISEUSERS, arrayContains: FirebaseUserService.currentUserID!).whereField(PROMISEENDTIME, isGreaterThan: now).order(by: PROMISEENDTIME).getDocuments { (snapShot, error) in
            if let err = error {
                debugPrint(err.localizedDescription)
            } else {
                let tempResult = PromiseTable.parseData(snapShot: snapShot)
                var temp1 = [DayAndPromise]()
                
                //10일 전부터 10일 후까지
                for i in stride(from: now3.timeIntervalSince1970 - (2592000 * 3), through: now3.timeIntervalSince1970 + (2592000 * 3), by: 86400) {
                    var temp2 = [PromiseTable]()
                    
                    for douc in tempResult {
                        if (i >= douc.promiseStartTime.timeIntervalSince1970) && (i <= douc.promiseEndTime.timeIntervalSince1970) {
                            temp2.append(douc)
                        }
                    }
                    
                    let temp3 = DayAndPromise(Day: Date(timeIntervalSince1970: i), promiseData: temp2)
                    temp1.append(temp3)
                }
                completion(temp1)
            }
        }
    }
}
