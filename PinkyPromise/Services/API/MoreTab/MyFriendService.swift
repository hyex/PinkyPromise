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
    
    fileprivate let userCollectionRef = Firestore.firestore().collection(PROMISEUSERREF)
    
    //유저의 친구들의 promiseUser들 가져온다.
    func getUsersFriendsData(completion: @escaping ([PromiseUser]) -> Void) {
        
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
