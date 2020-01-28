//
//  Api.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/14/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class MyApi: NSObject {
    
    static let shared = MyApi()
    
    fileprivate let promiseCollectionRef = Firestore.firestore().collection(PROMISETABLEREF)
    fileprivate let userCollectionRef = Firestore.firestore().collection(PROMISEUSERREF)
    fileprivate let progressCollectionRef = Firestore.firestore().collection(PROGRESSTABLEREF)
    
    var promiseListner: ListenerRegistration!
    
    let dateFormatter = DateFormatter()
    
    // Api 예시
    func allMore(completion: ([MoreTableData]) -> Void) { //}, onError: @escaping (Error) -> Void) {
        let result = [
            MoreTableData(title: "내 정보"),
            MoreTableData(title: "내 친구"),
            MoreTableData(title: "내 코드"),
        ]
        completion(result)
    }
    
    //유저 데이터가 업데이트될때마다 실행되며 업데이트된 데이터를 반환해줌, 클로저 사용
    func getUserUpdate(completion: @escaping ([PromiseUser]) -> Void) {
        var result = [PromiseUser]()
        promiseListner = userCollectionRef.whereField(USERID, isEqualTo: FirebaseUserService.currentUserID).addSnapshotListener({ (snapShot, error) in
            if let err = error {
                debugPrint(err)
            } else {
                result = PromiseUser.parseData(snapShot: snapShot)
                completion(result)
            }
        })
    }
    
    //유저 데이터를 반환해줌
    func getUserData(completion: @escaping ([PromiseUser]) -> Void) {
        var result = [PromiseUser]()
        userCollectionRef.whereField(USERID, isEqualTo: FirebaseUserService.currentUserID).getDocuments { (sanpShot, err) in
            if let err = err {
                debugPrint(err)
            }else {
                result = PromiseUser.parseData(snapShot: sanpShot)
                completion(result)
            }
        }
    }
    
    //약속 데이터를 반환
    func getPromiseData(completion: @escaping ([PromiseTable]) -> Void) {
        var result = [PromiseTable]()
        promiseCollectionRef.whereField(PROMISEUSERS, arrayContains: FirebaseUserService.currentUserID).getDocuments { (sanpShot, err) in
            if let err = err {
                debugPrint(err)
            }else {
                result = PromiseTable.parseData(snapShot: sanpShot)
                completion(result)
            }
        }
    }
    
    //약속 데이터가 업데이트되면 실행되며 업데이트되는 데이터를 받아줌
    func getPromiseUpdate(completion: @escaping ([PromiseTable]) -> Void) {
        var result = [PromiseTable]()
        
        //        promiseListner = promiseCollectionRef.order(by: PROMISEACHIEVEMENT, descending: true).addSnapshotListener({ (snapShot, error) in
        promiseListner = promiseCollectionRef.whereField(PROMISEUSERS, arrayContains: FirebaseUserService.currentUserID).addSnapshotListener({ (snapShot, error) in
            if let err = error {
                debugPrint(err)
            } else {
                result = PromiseTable.parseData(snapShot: snapShot)
                completion(result)
            }
        })
    }
    
    //프로그레스테이블의 정보 반환
    func getProgressData(completion: @escaping ([ProgressTable]) -> Void ){
        var result = [ProgressTable]()
        progressCollectionRef.whereField(USERID, isEqualTo: FirebaseUserService.currentUserID).getDocuments { (snapShot, error) in
            if let err = error {
                debugPrint("debug print \(err)")
            } else {
                result = ProgressTable.parseData(snapShot: snapShot)
                completion(result)
            }
        }
    }
    
    //프로그레스테이블의 정보를 날짜 기준으로 내림차순으로 반환
    func getProgressDataDesc(completion: @escaping ([ProgressTable]) -> Void ){
        var result = [ProgressTable]()
        progressCollectionRef.whereField(USERID, isEqualTo: FirebaseUserService.currentUserID).order(by: PROGRESSDAY, descending: true).getDocuments { (snapShot, error) in
            if let err = error {
                debugPrint("debug print \(err)")
            } else {
                result = ProgressTable.parseData(snapShot: snapShot)
                completion(result)
            }
        }
    }
    
    //프로그래스테이블의 데이터가 업데이트될때마다 프로그레스테이블을 날짜별로 소팅시켜서 반환
    func getProgressUpdateData(completion: @escaping ([ProgressTable]) -> Void) {
        var result = [ProgressTable]()
        promiseListner = promiseCollectionRef.whereField(USERID, isEqualTo: FirebaseUserService.currentUserID).order(by: PROGRESSDAY, descending: true).addSnapshotListener({ (snapShot, error) in
            if let err = error {
                debugPrint("debut print \(err)")
            } else {
                result = ProgressTable.parseData(snapShot: snapShot)
                completion(result)
            }
        })
    }
    
    //오늘을 기준으로 끝나지 않은 약속들만 반환
    func getPromiseDataSinceToday(completion: @escaping ([PromiseTable]) -> Void) {
        let result = Timestamp()
        
        promiseCollectionRef.whereField(USERID, isEqualTo: FirebaseUserService.currentUserID).whereField(PROMISEENDTIME, isGreaterThanOrEqualTo: result).getDocuments { (snapShot, error) in
            if let err = error {
                debugPrint(err.localizedDescription)
            } else {
                let tempResult = PromiseTable.parseData(snapShot: snapShot)
                completion(tempResult)
            }
        }
    }
    
    //약속 데이터를 추가할 때 사용하는 함수
    func addPromiseData(_ promiseTable: PromiseTable) {
        
        Firestore.firestore().collection(PROMISETABLEREF).addDocument(data: [
            PROMISENAME : promiseTable.promiseName ?? "Anomynous",
            PROMISECOLOR: promiseTable.promiseColor ?? "nil",
            PROMISEICON: promiseTable.promiseIcon ?? "nil",
            ISPROMISEACHIEVEMENT: promiseTable.isPromiseAchievement ?? false,
            PROMISESTARTTIME: promiseTable.promiseStartTime ?? Date(),
            PROMISEENDTIME: promiseTable.promiseEndTime ?? Date(),
            PROMSISEPANALTY: promiseTable.promisePanalty ?? "nil",
            PROMISEUSERS: promiseTable.promiseUsers ?? []
        ]) { error in
            if let err = error {
                debugPrint("Error adding document : \(err)")
            } else {
                print("parsing success")
            }
        }
        
    }
    
    //사용자 데이터를 추가할 때 사용하는 함수
    func addUserData(_ userTable: PromiseUser) {
        
        Firestore.firestore().collection(PROMISEUSERREF).addDocument(data: [
            USERNAME : userTable.userName ?? "Anomynous",
            USERFRIENDS: userTable.userFriends ?? [],
            USERID: userTable.userId ?? "nil",
            USERIMAGE: userTable.userImage ?? "404"
        ]) { error in
            if let err = error {
                debugPrint("Error adding document : \(err)")
            } else {
                print("this is API Error")
            }
        }
        
    }
    
    //프로그레스테이블에 데이터 추가
    func addProgressData(_ progressTable: ProgressTable) {
        Firestore.firestore().collection(PROGRESSTABLEREF).addDocument(data: [
            PROGRESSDAY: progressTable.progressDay ?? Timestamp(),
            PROGRESSDEGREE: progressTable.progressDegree ?? 0,
            PROMISEID: progressTable.promiseId ?? "nil",
            USERID: progressTable.userId ?? "nil"
        ]) { error in
            if let err = error {
                debugPrint("error adding document : \(err)")
            } else {
                print("this is API Error")
            }
        }
    }
    
    //유저를 uid를 이용해서 유저를 삭제하는 함수
    func deleteUserWithUid(Uid: String) {
        //let uid = Auth.auth().currentUser!.uid
        let uid = Uid
        
        Firestore.firestore().collection(PROMISEUSERREF).whereField(USERID, isEqualTo: uid).getDocuments { (snapshot, error) in
            if let err = error {
                print("get error in delete user with uid... with \(err)")
            } else {
                for document in snapshot!.documents {
                    document.reference.delete()
                }
            }
        }
        
        Firestore.firestore().collection(PROMISETABLEREF).document().updateData( [PROMISEUSERS : FieldValue.arrayRemove([])] )
        //물어봐야함
    }
    
    //약속을 약속 id를 사용해서 삭제하는 함수
    //약속 id는 약속 doucment id를 의미한다.
    func deletePromiseWithDocumentId(_ promiseId: String) {
        Firestore.firestore().collection(PROMISETABLEREF).document(promiseId).delete() { error in
            if let err = error {
                print("delete promise cause \(err)..")
            } else {
                print("delete promise success")
            }
        }
    }
    
    //progress를 uid를 사용해서 삭제하는함수
    func deleteProgressWithUid(Uid: String) {
        //let uid = Auth.auth().currentUser!.uid
        let uid = Uid
        
        Firestore.firestore().collection(PROGRESSTABLEREF).whereField(USERID, isEqualTo: uid).getDocuments { (snapshot, error) in
            if let err = error {
                print("delete user with uid cause \(err)...")
            } else {
                for document in snapshot!.documents {
                    document.reference.delete()
                }
            }
        }
        
        Firestore.firestore().collection(PROMISETABLEREF).document().updateData( [PROMISEUSERS : FieldValue.arrayRemove([])] )
        //물어봐야함
    }
    
    // VC file에 이렇게 사용
    //    MyApi.shared.allMenu(completion: { result in
    //               DispatchQueue.main.async {
    //                   self.moreTableList = result
    //                   self.moreTableView.reloadData()
    //               }
    //           })
    
    func allPromise(completion: @escaping ([PromiseData]) -> Void) {
        //}, onError: @escaping (Error) -> Void) {
        
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let defaultDate = Date(timeIntervalSince1970: 0)
        
        let result = [
            PromiseData(promiseName: "10시에 기상하기",
                        promiseStartTime: dateFormatter.date(from:"2020-01-18 10:00") ?? defaultDate,
                        promiseEndTime: dateFormatter.date(from:"2020-01-28 10:00") ?? defaultDate,
                        promiseColor: "green",
                        promiseAchievement: 3),
            PromiseData(promiseName: "4시에는 쿨쿨하기",
                        promiseStartTime: dateFormatter.date(from:"2020-01-20 13:00") ?? defaultDate,
                        promiseEndTime: dateFormatter.date(from:"2020-01-25 14:00") ?? defaultDate,
                        promiseColor: "lightGray",
                        promiseAchievement: 4),
            PromiseData(promiseName: "완료된 약속",
            promiseStartTime: dateFormatter.date(from:"2020-01-25 13:00") ?? defaultDate,
            promiseEndTime: dateFormatter.date(from:"2020-01-27 14:00") ?? defaultDate,
            promiseColor: "purple",
            promiseAchievement: 3),
            PromiseData(promiseName: "DARARARARA",
                        promiseStartTime: dateFormatter.date(from:"2020-01-18 10:00") ?? defaultDate,
                        promiseEndTime: dateFormatter.date(from:"2020-01-28 10:00") ?? defaultDate,
                        promiseColor: "orange",
                        promiseAchievement: 3),
            PromiseData(promiseName: "4시에는 쿨쿨하기",
                        promiseStartTime: dateFormatter.date(from:"2020-01-20 13:00") ?? defaultDate,
                        promiseEndTime: dateFormatter.date(from:"2020-01-25 14:00") ?? defaultDate,
                        promiseColor: "yellow",
                        promiseAchievement: 4),
            PromiseData(promiseName: "완료된 약속",
            promiseStartTime: dateFormatter.date(from:"2020-01-25 13:00") ?? defaultDate,
            promiseEndTime: dateFormatter.date(from:"2020-01-27 14:00") ?? defaultDate,
            promiseColor: "purple",
            promiseAchievement: 3),
            PromiseData(promiseName: "aassddff",
                        promiseStartTime: dateFormatter.date(from:"2020-01-18 10:00") ?? defaultDate,
                        promiseEndTime: dateFormatter.date(from:"2020-01-28 10:00") ?? defaultDate,
                        promiseColor: "systemPink",
                        promiseAchievement: 3),
            PromiseData(promiseName: "4시에는 쿨쿨하기",
                        promiseStartTime: dateFormatter.date(from:"2020-01-20 13:00") ?? defaultDate,
                        promiseEndTime: dateFormatter.date(from:"2020-01-25 14:00") ?? defaultDate,
                        promiseColor: "blue",
                        promiseAchievement: 4),
            PromiseData(promiseName: "완료된 약속",
                        promiseStartTime: dateFormatter.date(from:"2020-01-25 13:00") ?? defaultDate,
                        promiseEndTime: dateFormatter.date(from:"2020-01-27 14:00") ?? defaultDate,
                        promiseColor: "purple",
                        promiseAchievement: 3),
        ]
        completion(result)
        
    }
    
    
}
