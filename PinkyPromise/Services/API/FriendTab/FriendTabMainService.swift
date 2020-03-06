//
//  FriendTabMainService.swift
//  PinkyPromise
//
//  Created by SEONYOUNG LEE on 2020/02/25.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

class FriendTabMainService : NSObject {
    static let shared = FriendTabMainService()
        
        fileprivate let promiseCollectionRef = Firestore.firestore().collection(PROMISETABLEREF)
        fileprivate let userCollectionRef = Firestore.firestore().collection(PROMISEUSERREF)
        fileprivate let progressCollectionRef = Firestore.firestore().collection(PROGRESSTABLEREF)
        
        var promiseListner: ListenerRegistration!
        
        let dateFormatter = DateFormatter()
    
    //약속한 친구들 이름과 약속명
    func getPromiseNameAndFriendsName(completion: @escaping ([promiseNameAndFriendsName]) -> Void) {
        
        //self.fireStoreSetting()
        promiseCollectionRef.whereField(PROMISEUSERS, arrayContains: FirebaseUserService.currentUserID!).whereField(PROMISEENDTIME, isGreaterThanOrEqualTo: Date() ).getDocuments { (snapShot, error) in
            if let err = error {
                debugPrint(err.localizedDescription)
            }else {
                let tempResult = PromiseTable.parseData(snapShot: snapShot)
                var result1 = [promiseNameAndFriendsName]()
                var check = 0
                for douc in tempResult {
                    let FriendsList = douc.promiseUsers.filter { $0 != FirebaseUserService.currentUserID }
                    
                    let temp = promiseNameAndFriendsName(promiseName: douc.promiseName, promiseId: douc.promiseId, FirstuserImage: douc.promiseName, friendsName: FriendsList)
                    
                    if FriendsList.count == 0 {//친구가 없으면 패스하고 check에 1을 더해준다.
                        check += 1
                    } else {
                        self.getFriendsName(tempTable: temp) { (result) in
                            result1.append(result)
                            if result1.count + check >= tempResult.count {
                                completion(result1)
                            }
                        }
                    }
                }
            }
        }
    }
    
    //getPromiseNameAndFriendsName의 부속함수, 약속테이블의 사용자의 친구들의 이름을 반환함
    func getFriendsName(tempTable: promiseNameAndFriendsName, completion: @escaping (promiseNameAndFriendsName) -> Void ){
        
        //self.fireStoreSetting()
        var temp2 = [String]()
        let temp4 = tempTable.friendsName.sorted()
        for douc in temp4 {
            self.getUserNameWithUID(id: douc) { (result) in
                temp2.append(result)
                if temp2.count == tempTable.friendsName.count {
                    let temp3 = promiseNameAndFriendsName(promiseName: tempTable.promiseName, promiseId: tempTable.promiseId, FirstuserImage: temp4[0], friendsName: temp2.sorted())
                    completion(temp3)
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
