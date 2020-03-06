//
//  AddFriendCodeService.swift
//  PinkyPromise
//
//  Created by SEONYOUNG LEE on 2020/02/25.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

class AddFriendCodeService : NSObject {
    static let shared = AddFriendCodeService()
    
    fileprivate let promiseCollectionRef = Firestore.firestore().collection(PROMISETABLEREF)
    fileprivate let userCollectionRef = Firestore.firestore().collection(PROMISEUSERREF)
    fileprivate let progressCollectionRef = Firestore.firestore().collection(PROGRESSTABLEREF)
    
    var promiseListner: ListenerRegistration!
    
    let dateFormatter = DateFormatter()
    
    func addFriendWithCode(code: Int, completion: @escaping (PromiseUser?) -> Void) {
        userCollectionRef.whereField(USERCODE, isEqualTo: code).getDocuments { (snapShot, error) in
            if let err = error {
                debugPrint(err.localizedDescription)
            }else {
                let result = PromiseUser.parseData(snapShot: snapShot)
                //result는 원소가 1인 배열이거나 혹은 0인 배열
                
                if result.count > 0 {
                    //code를 가지는 사용자가 있다는 의미
                    
                    if result[0].userId != FirebaseUserService.currentUserID {
                        //본인이 아닐 경우 사용자에 친구 추가 누름
                        
                        self.getUserData { (result2) in
                            
                            var temp = result2[0].userFriends
                            
                            let tempadd = temp!.contains { $0 == (result[0].userId) }
                            
                            if tempadd == false {
                                temp?.append(result[0].userId)
                            }
                            
                            var temp2 = result[0].userFriends
                            temp2?.append(FirebaseUserService.currentUserID!)
                            self.userCollectionRef.document(result[0].userId).setData([USERFRIENDS : temp2], merge: true); self.userCollectionRef.document(FirebaseUserService.currentUserID!).setData( [USERFRIENDS : temp!], merge: true )
                        }
                    }
                    
                    self.getUserDataWithUID(id: result[0].userId) { (result) in
                        completion(result)
                    }
                } else {
                    //사용자가 없다. 고로 result는 0, 빈 배열
                    completion(nil)
                }
            }
        }
    }
    
    //유저 데이터를 반환해줌
    func getUserData(completion: @escaping ([PromiseUser]) -> Void) {
        var result = [PromiseUser]()
        //self.fireStoreSetting()
        userCollectionRef.whereField(USERID, isEqualTo: FirebaseUserService.currentUserID!).getDocuments { (sanpShot, err) in
            if let err = err {
                debugPrint(err)
            }else {
                result = PromiseUser.parseData(snapShot: sanpShot)
                completion(result)
            }
        }
    }
    
    //UID에 맞는 유저 데이터를 반환해줌
    func getUserDataWithUID(id: String, completion: @escaping (PromiseUser) -> Void) {
        //self.fireStoreSetting()
        var result = [PromiseUser]()
        userCollectionRef.whereField(USERID, isEqualTo: id).getDocuments { (sanpShot, err) in
            if let err = err {
                debugPrint(err)
            }else {
                result = PromiseUser.parseData(snapShot: sanpShot)
                let result2 = result[result.startIndex]
                completion(result2)
            }
        }
    }
    
    //UID를 가지고 친구추가하기
    func addFriendWithUID(UID: String, completion: @escaping (PromiseUser?) -> Void) {
        userCollectionRef.whereField(USERID, isEqualTo: UID).getDocuments { (snapShot, error) in
            if let err = error {
                debugPrint(err.localizedDescription)
            }else {
                let result = PromiseUser.parseData(snapShot: snapShot)
                //result는 원소가 1인 배열이거나 혹은 0인 배열
                
                if result.count > 0 {
                    //code를 가지는 사용자가 있다는 의미
                    
                    if result[0].userId != FirebaseUserService.currentUserID {
                        //본인이 아닐 경우 사용자에 친구 추가 누름
                        
                        self.getUserData { (result2) in
                            
                            var temp = result2[0].userFriends
                            
                            let tempadd = temp!.contains { $0 == (result[0].userId) }
                            
                            if tempadd == false {
                                temp?.append(result[0].userId)
                            }
                            
                            var temp2 = result[0].userFriends
                            temp2?.append(FirebaseUserService.currentUserID!)
                            self.userCollectionRef.document(result[0].userId).setData([USERFRIENDS : temp2], merge: true); self.userCollectionRef.document(FirebaseUserService.currentUserID!).setData( [USERFRIENDS : temp!], merge: true )
                        }
                    }
                    
                    self.getUserDataWithUID(id: result[0].userId) { (result) in
                        completion(result)
                    }
                } else {
                    //사용자가 없다. 고로 result는 0, 빈 배열
                    completion(nil)
                }
            }
        }
    }
}
