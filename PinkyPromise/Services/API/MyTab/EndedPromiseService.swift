//
//  EndedPromiseService.swift
//  PinkyPromise
//
//  Created by SEONYOUNG LEE on 2020/02/25.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

class EndedPromiseService: NSObject {
    static let shared = EndedPromiseService()
    
    fileprivate let promiseCollectionRef = Firestore.firestore().collection(PROMISETABLEREF)
    fileprivate let userCollectionRef = Firestore.firestore().collection(PROMISEUSERREF)
    fileprivate let progressCollectionRef = Firestore.firestore().collection(PROGRESSTABLEREF)
    
    var promiseListner: ListenerRegistration!
    
    let dateFormatter = DateFormatter()
    
    //이미 끝난 약속 데이터만 반환하는 함수
    func getCompletedPromiseData(completion: @escaping ([PromiseTable]) -> Void) {
        let result = Timestamp()
        //self.fireStoreSetting()
        promiseCollectionRef.whereField(PROMISEUSERS, arrayContains: FirebaseUserService.currentUserID!).whereField(PROMISEENDTIME, isLessThan: result).getDocuments { (snapShot, error) in
            if let err = error {
                debugPrint(err.localizedDescription)
            } else {
                let tempResult = PromiseTable.parseData(snapShot: snapShot)
                self.getPerfectCompletedPromiseData(promises: tempResult, completion: { result in
                    completion(result)
                })
            }
        }
        
    }
    
    //끝난 약속 데이터를 인풋으로, 이중에서 프로그레스 배열이 모두 4인 경우만 약속 반환
    func getPerfectCompletedPromiseData(promises: [PromiseTable], completion: @escaping ([PromiseTable]) -> Void) {
        var result = [PromiseTable]()
        //self.fireStoreSetting()
        
        var countcheck = 0
        for douc in promises {
            progressCollectionRef.whereField(USERID, isEqualTo: FirebaseUserService.currentUserID!).whereField(PROMISEID, isEqualTo: douc.promiseId).getDocuments { (snapShot, error) in
                if let err = error {
                    debugPrint(err.localizedDescription)
                } else {
                    let tempResult = ProgressTable.parseData(snapShot: snapShot)
                    
                    if tempResult.count > 0 {
                        let check4 = tempResult[0].progressDegree.contains { $0 < 4 }
                        
                        if check4 == false {
                            result.append(douc)
                            if promises.count <= countcheck {
                                completion(result)
                            }
                        }
                    }
                }
            }
            countcheck += 1
        }
    }
    
    //약속 아이디를 가지고 약속한 친구의 이름들을 반환하는 함수
    func getPromiseFriendsNameWithPID(promiseID: String, completion: @escaping ([String]) -> Void) {
        //self.fireStoreSetting()
        promiseCollectionRef.whereField(PROMISEID, isEqualTo: promiseID).getDocuments { (snapsHot, error ) in
            if let err = error {
                debugPrint(err.localizedDescription)
            } else {
                let tempResult = PromiseTable.parseData(snapShot: snapsHot)
                var temp = [String]()
                
                let usersNotMe = tempResult[0].promiseUsers.filter { $0 != FirebaseUserService.currentUserID }
                
                for douc in usersNotMe {
                    self.getUserNameWithUID(id: douc) { (result) in
                        temp.append(result)
                        if temp.count == usersNotMe.count {
                            completion(temp)
                        }
                    }
                }
                
            }
        }
    }
    
    //UID에 맞는 유저 이름을 반환해줌
    func getUserNameWithUID(id: String, completion: @escaping (String) -> Void) {
        //self.fireStoreSetting()
        
        userCollectionRef.whereField(USERID, isEqualTo: id).getDocuments { (sanpShot, err) in
            if let err = err {
                debugPrint(err)
            }else {
                let result = PromiseUser.parseData(snapShot: sanpShot)
                if result.count > 0 {
                    completion(result[0].userName)
                }
                
            }
        }
    }
}

