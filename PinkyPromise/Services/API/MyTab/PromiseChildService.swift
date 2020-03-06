//
//  PromiseChildService.swift
//  PinkyPromise
//
//  Created by SEONYOUNG LEE on 2020/02/25.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

class PromiseChildService: NSObject {
    
    static let shared = PromiseChildService()
    
    fileprivate let promiseCollectionRef = Firestore.firestore().collection(PROMISETABLEREF)
    fileprivate let progressCollectionRef = Firestore.firestore().collection(PROGRESSTABLEREF)
    
    //오늘을 기준으로 끝나지 않은 약속들만 반환
    func getPromiseDataSinceToday(completion: @escaping ([PromiseTable]) -> Void) {
        let now3 = Date(timeIntervalSince1970: ceil(Date().timeIntervalSince1970/86400)*86400 + 21600 - (15*3600))
        //self.fireStoreSetting()
        
        promiseCollectionRef.whereField(PROMISEUSERS, arrayContains: FirebaseUserService.currentUserID!).whereField(PROMISEENDTIME, isGreaterThanOrEqualTo: now3).getDocuments { (snapShot, error) in
            if let err = error {
                debugPrint(err.localizedDescription)
            } else {
                let tempResult = PromiseTable.parseData(snapShot: snapShot)
                completion(tempResult)
            }
        }
    }
    
    //약속 id를 인풋으로 프로그레스테이블의 정보 반환
    func getProgressDataWithPromiseId(promiseid: String, completion: @escaping ([ProgressTable]) -> Void ){

        var result: [ProgressTable] = [] //[ProgressTable]()]
        //        var result: [ProgressTable]? = nil
        progressCollectionRef.whereField(USERID, isEqualTo: FirebaseUserService.currentUserID!).whereField(PROMISEID, isEqualTo: promiseid).getDocuments { (snapShot, error) in
            if let err = error {
                debugPrint("debug print \(err)")
            } else {
                result = ProgressTable.parseData(snapShot: snapShot)
                completion(result)
                
            }
        }
    }
    
    
}
