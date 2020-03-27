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
            } else {
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
            } else {
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
                } else {
                    print("AddProgressData API is success")
                }
            }
        }
    }
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if length == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        //let index = result.index(result.startIndex, offsetBy: 20)
        return String(result.prefix(20))
    }
    
}

