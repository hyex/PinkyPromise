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
    
    fileprivate let userCollectionRef = Firestore.firestore().collection(PROMISEUSERREF)
    
    func addFriendWithCode(code: Int, completion: @escaping (PromiseUser?) -> Void) {
        userCollectionRef.whereField(USERCODE, isEqualTo: code).getDocuments { (snapShot, error) in
            if let err = error {
                debugPrint(err.localizedDescription)
            }else {
                let result = PromiseUser.parseData(snapShot: snapShot)
                //result는 원소가 1인 배열이거나 혹은 0인 배열, 코드를 입력했을때 그코드에 맞는 사용자가 있다.
                
                if result.count > 0 {
                    //code를 가지는 사용자가 있다는 의미
                    
                    if result[0].userId != FirebaseUserService.currentUserID {
                        //본인이 아닐 경우 사용자에 친구 추가 누름
                        
                        self.getUserData { (result2) in
                            
                            var temp = result2[0].userFriends//나의 친구들
                            let tempadd = temp!.contains { $0 == (result[0].userId) }//나의 친구들 중에 친구가 이미 있는지검사
                            if tempadd == false {//친구가 없으면
                                temp?.append(result[0].userId)//내 친구목록에 추가
                            }
                            var temp2 = result[0].userFriends//친구의 친구들
                            let tempadd2 = temp2!.contains { $0 == FirebaseUserService.currentUserID }//친구의 친구목록중 내가 있는지 검사
                            if tempadd2 == false {//친구가 없으면
                                temp2?.append(FirebaseUserService.currentUserID!)
                            }
                            self.userCollectionRef.document(result[0].userId).setData([USERFRIENDS : temp2!], merge: true); self.userCollectionRef.document(FirebaseUserService.currentUserID!).setData( [USERFRIENDS : temp!], merge: true )
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
        
        userCollectionRef.document(FirebaseUserService.currentUserID!).getDocument { (document, error) in
            if let err = error {
                debugPrint(err)
                completion(result)
            } else {
                //let dataDescription = document?.data()
                result = PromiseUser.parseDouc(snapShot: document)
                completion(result)
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
