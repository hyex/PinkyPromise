//
//  Promise.swift
//  PinkyPromise
//
//  Created by apple on 2020/01/19.
//  Copyright © 2020 hyejikim. All rights reserved.
//
import Foundation
import Firebase

class PromiseTable {
    private(set) var promiseName: String!
    private(set) var promiseStartTime: Date
    private(set) var promiseEndTime: Date
    private(set) var promiseColor: String!
    private(set) var promiseIcon: String!
    private(set) var promiseUsers: Array<String>
    private(set) var isPromiseAchievement: Bool!
    private(set) var promisePanalty: String!
    private(set) var promiseId: String!
    
    init(promiseName: String
        ,promiseStartTime: Date
        ,promiseEndTime: Date
        ,promiseColor: String
        ,promiseIcon: String
        ,promiseUsers: Array<String>!
        ,isPromiseAchievement: Bool
        ,promisePanalty: String
        ,promiseId: String) {
        self.promiseIcon = promiseIcon
        self.promiseName = promiseName
        self.promiseColor = promiseColor
        self.promiseStartTime = promiseStartTime
        self.promiseEndTime = promiseEndTime
        self.promiseUsers = promiseUsers
        self.isPromiseAchievement = isPromiseAchievement
        self.promisePanalty = promisePanalty
        self.promiseId = promiseId
    }
    
    class func parseData(snapShot: QuerySnapshot?) -> [PromiseTable] {
        var promise = [PromiseTable]()
        
        guard let snap = snapShot else { return promise }
        for document in snap.documents {
            let data = document.data()
            
            let dataName = data[PROMISENAME] as? String ?? "Anonymous"
            let dataStartTime = data[PROMISESTARTTIME] as? Timestamp ?? Timestamp()
            let dataEndTime = data[PROMISEENDTIME] as? Timestamp ?? Timestamp()
            let dataColor = data[PROMISECOLOR] as? String ?? "not given color"
            let dataIcon = data[PROMISEICON] as? String ?? "Nothing Icon"
            let dataUsers = data[PROMISEUSERS] as? Array<String> ?? []
            let isDataAchievment = data[ISPROMISEACHIEVEMENT] as? Bool ?? false
            let dataPromisePanalty = data[PROMSISEPANALTY] as? String ?? "not given coler"
            let dataPromiseId = document.documentID
//            print("this is dataPromiseId + \(dataPromiseId)")
            
            let newPromise = PromiseTable(promiseName: dataName, promiseStartTime: dataStartTime.dateValue() + 32400, promiseEndTime: dataEndTime.dateValue() + 32400, promiseColor: dataColor, promiseIcon: dataIcon, promiseUsers: dataUsers, isPromiseAchievement: isDataAchievment, promisePanalty: dataPromisePanalty, promiseId: dataPromiseId)
            
            promise.append(newPromise)
        }
        return promise
    }
    
}
