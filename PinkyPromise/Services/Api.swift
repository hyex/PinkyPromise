//
//  Api.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/14/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import Foundation
import Firebase

class MyApi: NSObject {
    static let shared = MyApi()
    
    fileprivate let promiseCollectionRef = Firestore.firestore().collection(PROMISETABLEREF)
    fileprivate let userCollectionRef = Firestore.firestore().collection(PROMISEUSERREF)
    
    var promiseListner: ListenerRegistration!
    
    // Api 예시
    func allMenu(completion: ([MoreTableData]) -> Void) { //}, onError: @escaping (Error) -> Void) {
        let result = [
            MoreTableData(title: "예제1"),
            MoreTableData(title: "예제2"),
            MoreTableData(title: "예제3"),
        ]
        completion(result)
    }
    
    func tempPromise(by userId:String, completion: ([PromiseTable]) -> Void) {
        
        let id = "" // userId
        
        completion([])
    }
    
    func getUserUpdate(completion: @escaping ([PromiseUser]) -> Void) {
        var result = [PromiseUser]()
        promiseListner = userCollectionRef.addSnapshotListener({ (snapShot, error) in
            if let err = error {
                debugPrint(err)
            } else {
                result = PromiseUser.parseData(snapShot: snapShot)
                completion(result)
            }
        })
    }
    
    func getUserData(completion: @escaping ([PromiseUser]) -> Void) {
        var result = [PromiseUser]()
        userCollectionRef.getDocuments { (sanpShot, err) in
            if let err = err {
                debugPrint(err)
            }else {
                result = PromiseUser.parseData(snapShot: sanpShot)
                completion(result)
            }
        }
    }
    
    func getPromiseData(completion: @escaping ([PromiseTable]) -> Void) {
        var result = [PromiseTable]()
        promiseCollectionRef.getDocuments { (sanpShot, err) in
            if let err = err {
                debugPrint(err)
            }else {
                result = PromiseTable.parseData(snapShot: sanpShot)
                completion(result)
            }
        }
    }
    
    func getPromiseUpdate(completion: @escaping ([PromiseTable]) -> Void) {
        var result = [PromiseTable]()
        
        promiseListner = promiseCollectionRef.order(by: PROMISEACHIEVEMENT, descending: true).addSnapshotListener({ (snapShot, error) in
            if let err = error {
                debugPrint(err)
            } else {
                result = PromiseTable.parseData(snapShot: snapShot)
                completion(result)
            }
        })
        
    }
    
    //약속 데이터를 추가할 때 사용하는 함수
    func addPromiseData(_ promiseTable: PromiseTable) {
        
        Firestore.firestore().collection(PROMISETABLEREF).addDocument(data: [
            PROMISENAME : promiseTable.promiseName,
            PROMISECOLOR: promiseTable.promiseColor,
            PROMISEICON: promiseTable.promiseIcon,
            PROMISEACHIEVEMENT: promiseTable.promiseAchievement,
            PROMISESTARTTIME: promiseTable.promiseStartTime,
            PROMISEENDTIME: promiseTable.promiseEndTime,
            ISPROMISEALARM: promiseTable.isPromiseAlarm,
            PROMISEALARMCONTENT: promiseTable.promiseAlarmContent,
            PROMISEUSERS: promiseTable.promiseUsers
        ]) { error in
            if let err = error {
                debugPrint("Error adding document : \(error)")
            } else {
                print("parsing success")
            }
        }
        
    }
    
    //사용자 데이터를 추가할 때 사용하는 함수
    func addUserData(_ userTable: PromiseUser) {
        
        Firestore.firestore().collection(PROMISEUSERREF).addDocument(data: [
            USERNAME : userTable.userName,
        ]) { error in
            if let err = error {
                debugPrint("Error adding document : \(error)")
            } else {
                print("this is API Error")
            }
        }
        
    }
    
}
// VC file에 이렇게 사용
//    MyApi.shared.allMenu(completion: { result in
//               DispatchQueue.main.async {
//                   self.moreTableList = result
//                   self.moreTableView.reloadData()
//               }
//           })


