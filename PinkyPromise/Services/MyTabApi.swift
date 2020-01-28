//
//  MyTab.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/28/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore


class MyTabApi: NSObject {
    
    static let shared = MyTabApi()
    
    fileprivate let promiseCollectionRef = Firestore.firestore().collection(PROMISETABLEREF)
    fileprivate let userCollectionRef = Firestore.firestore().collection(PROMISEUSERREF)
    fileprivate let progressCollectionRef = Firestore.firestore().collection(PROGRESSTABLEREF)
    
    var promiseListner: ListenerRegistration!
    
    let dateFormatter = DateFormatter()
    
    
    //오늘을 기준으로 끝나지 않은 약속들만 반환
    func getPromiseDataSinceToday(completion: @escaping ([PromiseTable]) -> Void) {
        let result = Timestamp()
        
        promiseCollectionRef.whereField(PROMISEUSERS, arrayContains: FirebaseUserService.currentUserID).whereField(PROMISEENDTIME, isGreaterThanOrEqualTo: result).getDocuments { (snapShot, error) in
            if let err = error {
                debugPrint(err.localizedDescription)
            } else {
                let tempResult = PromiseTable.parseData(snapShot: snapShot)
                completion(tempResult)
            }
        }
    }
    
    //프로그레스테이블의 정보 반환 약속 id를 반환하면
    func getProgressData(promiseid: String, completion: @escaping ([ProgressTable]) -> Void ){
        var result = [ProgressTable]()
        progressCollectionRef.whereField(USERID, isEqualTo: FirebaseUserService.currentUserID).whereField(PROMISEID, isEqualTo: promiseid).getDocuments { (snapShot, error) in
            if let err = error {
                debugPrint("debug print \(err)")
            } else {
                result = ProgressTable.parseData(snapShot: snapShot)
                completion(result)
            }
        }
    }
    
    func getAllProgressData(completion: @escaping ([ProgressTable]) -> Void ){
        var result = [ProgressTable]()
        progressCollectionRef.whereField(USERID, isEqualTo: FirebaseUserService.currentUserID).getDocuments { (snapShot, error) in
            if let err = error {
                debugPrint("debug print \(err)")
            } else {
                result = ProgressTable.parseData(snapShot: snapShot)
                completion(result)
            }
        }
    }
}
