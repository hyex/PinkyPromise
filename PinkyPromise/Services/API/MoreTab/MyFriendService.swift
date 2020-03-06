//
//  MyFriendService.swift
//  PinkyPromise
//
//  Created by SEONYOUNG LEE on 2020/02/25.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

class MyFriendService : NSObject {
    static let shared = MyFriendService()
    
    fileprivate let promiseCollectionRef = Firestore.firestore().collection(PROMISETABLEREF)
    fileprivate let userCollectionRef = Firestore.firestore().collection(PROMISEUSERREF)
    fileprivate let progressCollectionRef = Firestore.firestore().collection(PROGRESSTABLEREF)
    
    var promiseListner: ListenerRegistration!
    
    let dateFormatter = DateFormatter()
    
    //유저의 친구들의 promiseUser들 가져온다.
    func getUsersFriendsData(completion: @escaping ([PromiseUser]) -> Void) {
        //self.fireStoreSetting()
        //        userCollectionRef.whereField(USERID, isEqualTo: FirebaseUserService.currentUserID!).getDocuments { (snapShot, error) in
        //            if let err = error {
        //                debugPrint(err.localizedDescription)
        //            } else {
        //                let tempResult = PromiseUser.parseData(snapShot: snapShot)
        //                var temp = [PromiseUser]()
        //                var check1 = 0
        //
        //                if tempResult.count > 0 {
        //                    for douc in tempResult[0].userFriends {
        //                        self.getUserDataWithUID(id: douc) { (result) in
        //                            temp.append(result)
        //                            check1 += 1
        //                            if tempResult[0].userFriends.count <= check1 {
        //                                completion(temp)
        //                            }
        //                        }
        //                    }
        //                }
        //
        //            }
        //        }
        
        userCollectionRef.document(FirebaseUserService.currentUserID!).getDocument { (snapShot, error) in
            if let err = error {
                debugPrint(err.localizedDescription)
            } else {
                let tempResult = PromiseUser.parseDouc(snapShot: snapShot)
                var temp = [PromiseUser]()
                var check1 = 0
                
                for douc in tempResult[0].userFriends {
                    self.getUserDataWithUID(id: douc) { (result) in
                        temp.append(result)
                        check1 += 1
                        if tempResult[0].userFriends.count <= check1 {
                            completion(temp)
                        }
                    }
                }
            }
        }
    }
    
    //UID에 맞는 유저 데이터를 반환해줌
        func getUserDataWithUID(id: String, completion: @escaping (PromiseUser) -> Void) {
            //self.fireStoreSetting()
    //        var result = [PromiseUser]()
    //        userCollectionRef.whereField(USERID, isEqualTo: id).getDocuments { (sanpShot, err) in
    //            if let err = err {
    //                debugPrint(err)
    //            }else {
    //                result = PromiseUser.parseData(snapShot: sanpShot)
    //                let result2 = result[result.startIndex]
    //                completion(result2)
    //            }
    //        }
            
            var result = [PromiseUser]()
            userCollectionRef.document(id).getDocument { (sanpShot, err) in
                if let err = err {
                    debugPrint(err)
                }else {
                    result = PromiseUser.parseDouc(snapShot: sanpShot)
                    let result2 = result[result.startIndex]
                    completion(result2)
                }
            }
        }
}
