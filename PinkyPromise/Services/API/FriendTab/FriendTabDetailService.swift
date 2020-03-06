//
//  FriendTabDetailService.swift
//  PinkyPromise
//
//  Created by SEONYOUNG LEE on 2020/02/25.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

class FriendTabDetailService : NSObject {
    static let shared = FriendTabDetailService()
        
        fileprivate let promiseCollectionRef = Firestore.firestore().collection(PROMISETABLEREF)
        fileprivate let userCollectionRef = Firestore.firestore().collection(PROMISEUSERREF)
        fileprivate let progressCollectionRef = Firestore.firestore().collection(PROGRESSTABLEREF)
        
        var promiseListner: ListenerRegistration!
        
        let dateFormatter = DateFormatter()
    
    func getDataforDetailViewjr1(promiseID: String, completion: @escaping (promiseDetail) -> Void) {
        promiseCollectionRef.whereField(PROMISEID, isEqualTo: promiseID).getDocuments { (snapshot, error) in
            if let err = error {
                debugPrint(err.localizedDescription)
            } else {
                let result = PromiseTable.parseData(snapShot: snapshot)
                
                if result.count > 0 {
                    let promiseDay = Double( (result[0].promiseEndTime.timeIntervalSince1970 - result[0].promiseStartTime.timeIntervalSince1970) / 86400)
                    
                    let promiseDaysinceToday = Double( ( Date(timeIntervalSince1970: ceil(Date().timeIntervalSince1970/86400)*86400 + 21600 - (15*3600)).timeIntervalSince1970 - result[0].promiseStartTime.timeIntervalSince1970 ) / 86400 )
                    
                    let temp = promiseDetailjunior1(promiseName: result[0].promiseName, promiseDay: promiseDay, promiseDaySinceStart: promiseDaysinceToday, friendsUIDList: result[0].promiseUsers)
                    
                    self.getDataForDetailViewjr2(detailData1: temp) { (result2) in
                        
                        completion(result2)
                    }
                }
            }
        }
    }
    
    func getDataForDetailViewjr2(detailData1: promiseDetailjunior1, completion: @escaping (promiseDetail) -> Void) {
        
        var temp4 = [promiseDetailChild]()
        
        for douc in detailData1.friendsUIDList {
            self.getUserDataWithUID(id: douc) { (result3) in
                
                self.getProgressDataWithUid(userid: douc) { (result4) in
                    
                    var temp6 = Array<Int>(repeating: 0, count: 5)
                    
                    if result4.count > 0 {
                        for i in result4[0].progressDegree {
                            switch i {
                            case 0:
                                temp6[i] += 1
                            case 1:
                                temp6[i] += 1
                            case 2:
                                temp6[i] += 1
                            case 3:
                                temp6[i] += 1
                            case 4:
                                temp6[i] += 1
                            case -1:
                                print("")
                            //-1은 안한거다.
                            default:
                                print("cuase default at getDataForDetailViewjr2")
                            }
                        }
                    }
                    
                    let zek = promiseDetailChild(friendName: result3.userName, friendImage: result3.userImage, friendDegree: temp6)
                    temp4.append(zek)
                    
                    if temp4.count == detailData1.friendsUIDList.count {
                    
                        temp4.sort { $0.friendName < $1.friendName }
                        
                        completion(promiseDetail(promiseName: detailData1.promiseName, promiseDay: detailData1.promiseDay, promiseDaySinceStart: detailData1.promiseDaySinceStart, friendsDetail: temp4))
                        
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
    
    //프로그레스테이블에 원하는 유저의 uid를 인풋으로 그 유저의 프로그레스 정보를 알 수 있다
    func getProgressDataWithUid(userid: String, completion: @escaping ([ProgressTable]) -> Void ) {
        //self.fireStoreSetting()
        var result = [ProgressTable]()
        progressCollectionRef.whereField(USERID, isEqualTo: userid).getDocuments { (snapShot, error) in
            
            if let err = error {
                debugPrint("debug print \(err)")
            } else {
                result = ProgressTable.parseData(snapShot: snapShot)
                completion(result)
            }
            
        }
    }
    
}
