//
//  MoreTabMainService.swift
//  PinkyPromise
//
//  Created by SEONYOUNG LEE on 2020/02/25.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

class MoreTabMainService : NSObject {
    static let shared = MoreTabMainService()
    
    fileprivate let userCollectionRef = Firestore.firestore().collection(PROMISEUSERREF)
    
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
    
}
