//
//  AddProgressService.swift
//  PinkyPromise
//
//  Created by SEONYOUNG LEE on 2020/02/25.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

class AddProgressService : NSObject {
    static let shared = AddProgressService()
    
    fileprivate let promiseCollectionRef = Firestore.firestore().collection(PROMISETABLEREF)
    fileprivate let userCollectionRef = Firestore.firestore().collection(PROMISEUSERREF)
    fileprivate let progressCollectionRef = Firestore.firestore().collection(PROGRESSTABLEREF)
    
    var promiseListner: ListenerRegistration!
    
    let dateFormatter = DateFormatter()
    
    var delegate: SendProgressDelegate!
    var networkDelegate: SendNetWorkConnectionDelegate!
    
    //약속 데이터를 반환// Input: PromiseID   Output: PromiseTable
    func getPromiseDataWithPromiseId(promiseid: String, completion: @escaping ([PromiseTable]) -> Void ){
        //self.fireStoreSetting()
        var result: [PromiseTable] = [] //[ProgressTable]()]
        //        var result: [ProgressTable]? = nil
        promiseCollectionRef.whereField(PROMISEID, isEqualTo: promiseid).getDocuments { (snapShot, error) in
            if let err = error {
                debugPrint("debug print \(err)")
            } else {
                result = PromiseTable.parseData(snapShot: snapShot)
                completion(result)
                
            }
        }
    }
    
    //프로그레스테이블의 정보 반환 약속 id를 반환하면
    func getProgressDataWithPromiseId(promiseid: String, completion: @escaping ([ProgressTable]) -> Void ){
        //self.fireStoreSetting()
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
    
    //프로그레스 입력뷰
    func updateProgress(day: Date, userId: String, data: Int, promise: PromiseTable){
        progressCollectionRef.whereField(USERID, isEqualTo: userId).whereField(PROMISEID, isEqualTo: promise.promiseId!).getDocuments { (snapShot, error) in
            if let err = error {
                debugPrint(err.localizedDescription)
            } else {
                //프로그레스 갖고오기
                let progressTemp = ProgressTable.parseData(snapShot: snapShot)
                
                let datindex = Int(day.timeIntervalSince1970 - promise.promiseStartTime.timeIntervalSince1970) / 86400
                var temp: [Int] = progressTemp[0].progressDegree
                temp[datindex] = data
                self.progressCollectionRef.document((snapShot?.documents[0].documentID)!).updateData([PROGRESSDEGREE : temp]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                        self.delegate.sendProgress(data: data)
                        // if endDate
                        if temp.filter({$0 != 4}).count == 0 {
                            AddProgressService.shared.updatePromiseAchievementTrue(promiseID: promise.promiseId)
                        } else if promise.isPromiseAchievement == true {
                            AddProgressService.shared.updatePromiseAchievementFalse(promiseID: promise.promiseId)
                        }
                    }
                    
                }
            }
        }
    }
    
    //프로미스 어치브먼트 바꾸는함수
    func updatePromiseAchievementTrue(promiseID: String) {
        promiseCollectionRef.document(promiseID).updateData([ISPROMISEACHIEVEMENT : true])
    }
    
    //프로미스 어치브먼트 바꾸는함수
    func updatePromiseAchievementFalse(promiseID: String) {
        promiseCollectionRef.document(promiseID).updateData([ISPROMISEACHIEVEMENT : false])
    }
    
}
