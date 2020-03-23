//
//  AddPromiseService.swift
//  PinkyPromise
//
//  Created by SEONYOUNG LEE on 2020/02/25.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore
import SystemConfiguration

//var connectedToNetwork: Bool {
//
//    get {
//        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
//        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
//        zeroAddress.sin_family = sa_family_t(AF_INET)
//
//        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
//            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
//                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
//
//            }
//        }
//        
//        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
//        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
//            return false
//        }
//
//        /* Only Working for WIFI
//         let isReachable = flags == .reachable
//         let needsConnection = flags == .connectionRequired
//
//         return isReachable && !needsConnection
//         */
//
//        // Working for Cellular and WIFI
//        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
//        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
//        let ret = (isReachable && !needsConnection)
//
//        return ret
//    }
//
//}

class AddPromiseService : NSObject {
    static let shared = AddPromiseService()
    
    fileprivate let promiseCollectionRef = Firestore.firestore().collection(PROMISETABLEREF)
    fileprivate let userCollectionRef = Firestore.firestore().collection(PROMISEUSERREF)
    fileprivate let progressCollectionRef = Firestore.firestore().collection(PROGRESSTABLEREF)
    
    var promiseListner: ListenerRegistration!
    
    var delegate: SendPromiseDelegate!
    var networkDelegate: SendNetWorkConnectionDelegate!
    let dateFormatter = DateFormatter()
    
    
    //유저 데이터를 반환해줌
    func getUserData(completion: @escaping ([PromiseUser]) -> Void) {
        var result = [PromiseUser]()
        //self.fireStoreSetting()
        
        userCollectionRef.document(FirebaseUserService.currentUserID!).getDocument { (document, error) in
            if let err = error {
                debugPrint(err)
                if connectedToNetwork == false {
                    print("check wifi")
                    self.networkDelegate.sendData(data: connectedToNetwork)
                }
                completion(result)
            } else {
                if connectedToNetwork == false {
                    print("check wifi")
                    self.networkDelegate.sendData(data: connectedToNetwork)
                }
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
                if connectedToNetwork == false {
                    print("check wifi")
                    self.networkDelegate.sendData(data: connectedToNetwork)
                }
            } else {
                if connectedToNetwork == false {
                    print("check wifi")
                    self.networkDelegate.sendData(data: connectedToNetwork)
                }
                result = PromiseUser.parseDouc(snapShot: sanpShot)
                let result2 = result[result.startIndex]
                completion(result2)
            }
        }
    }
    
    //약속 데이터를 추가할 때 사용하는 함수
    func addPromiseData(_ promiseTable: PromiseTable) {
        
        var temp = promiseTable.promiseUsers
        temp.append(FirebaseUserService.currentUserID!)
        
        promiseCollectionRef.document(promiseTable.promiseId).setData([
            PROMISENAME : promiseTable.promiseName ?? "Anomynous",
            PROMISECOLOR: promiseTable.promiseColor ?? "nil",
            PROMISEICON: promiseTable.promiseIcon ?? "nil",
            ISPROMISEACHIEVEMENT: promiseTable.isPromiseAchievement ?? false,
            PROMISESTARTTIME: promiseTable.promiseStartTime,
            PROMISEENDTIME: promiseTable.promiseEndTime,
            PROMSISEPANALTY: promiseTable.promisePanalty ?? "nil",
            PROMISEUSERS: temp,
            PROMISEID: promiseTable.promiseId ?? "nil"
        ]) { error in
            if let err = error {
                debugPrint("Error adding document : \(err)")
                if connectedToNetwork == false {
                    print("check wifi")
                    self.networkDelegate.sendData(data: connectedToNetwork)
                }
            } else {
                if connectedToNetwork == false {
                    print("check wifi")
                    self.networkDelegate.sendData(data: connectedToNetwork)
                }
                print("AddPromiseData API is success")
                self.delegate.sendPromise()
            }
        }
    }
    
    //프로그레스테이블에 데이터 추가, addPromiseTable 직후 같은 promiseTable을 넣어준다.
    func addProgressData(_ promiseTable: PromiseTable) {
        
        var temp = promiseTable.promiseUsers
        temp.append(FirebaseUserService.currentUserID!)
        
        let indexTime = Int(promiseTable.promiseEndTime.timeIntervalSince1970 - promiseTable.promiseStartTime.timeIntervalSince1970) / 86400
        let indexPromiseId = promiseTable.promiseId
        
        for douc in temp { //약속에 있는 유저 개수만큼 progressTable을 만든다.
            let temp1 = [Int](repeating: -1, count: indexTime + 1)
            
            progressCollectionRef.addDocument( data: [
                PROGRESSDEGREE: temp1,
                PROMISEID: indexPromiseId ?? "nil",
                USERID: douc
            ]) { error in
                if let err = error {
                    debugPrint("error adding document : \(err)")
                    if connectedToNetwork == false {
                        print("check wifi")
                        self.networkDelegate.sendData(data: connectedToNetwork)
                    }
                } else {
                    if connectedToNetwork == false {
                        print("check wifi")
                        self.networkDelegate.sendData(data: connectedToNetwork)
                    }
                    print("AddProgressData API is success")
                }
            }
        }
    }
    
}

