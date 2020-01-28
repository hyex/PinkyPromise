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
    private(set) var isPromiseAlarm: Bool!
    private(set) var promiseStartTime: Date!
    private(set) var promiseEndTime: Date!
    private(set) var promiseColor: String!
    private(set) var promiseAlarmContent: String!
    private(set) var promiseIcon: String!
    private(set) var promiseAlarmTime: Date!
    private(set) var promiseUsers: Array<String>!
    private(set) var isPromiseAchievement: Bool!
    private(set) var promisePanalty: String!
    private(set) var promiseId: String!
    
    init(promiseName: String
        ,isPromiseAlarm: Bool
        ,promiseStartTime: Date
        ,promiseEndTime: Date
        ,promiseColor: String
        ,promiseIcon: String
        ,promiseAlarmTime: Date
        ,promiseUsers: Array<String>!
        ,isPromiseAchievement: Bool
        ,promisePanalty: String
        ,promiseId: String) {
        self.promiseIcon = promiseIcon
        self.promiseName = promiseName
        self.promiseColor = promiseColor
        self.promiseStartTime = promiseStartTime
        self.promiseEndTime = promiseEndTime
        self.promiseAlarmTime = promiseAlarmTime
        self.isPromiseAlarm = isPromiseAlarm
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
            let isDataAlarm = data[ISPROMISEALARM] as? Bool ?? false
            let dataStartTime = data[PROMISESTARTTIME] as? Timestamp ?? Timestamp()
            let dataEndTime = data[PROMISEENDTIME] as? Timestamp ?? Timestamp()
            let dataColor = data[PROMISECOLOR] as? String ?? "not given color"
            let dataIcon = data[PROMISEICON] as? String ?? "Nothing Icon"
            let dataUsers = data[PROMISEUSERS] as? Array<String> ?? []
            let dataAlarmTime = data[PROMISEALARMTIME] as? Timestamp ?? Timestamp()
            let isDataAchievment = data[ISPROMISEACHIEVEMENT] as? Bool ?? false
            let dataPromisePanalty = data[PROMSISEPANALTY] as? String ?? "not given coler"
            let dataPromiseId = document.documentID
//            print("this is dataPromiseId + \(dataPromiseId)")
            
            let newPromise = PromiseTable(promiseName: dataName, isPromiseAlarm: isDataAlarm, promiseStartTime: dataStartTime.dateValue() + 32400, promiseEndTime: dataEndTime.dateValue() + 32400, promiseColor: dataColor, promiseIcon: dataIcon, promiseAlarmTime: dataAlarmTime.dateValue() + 32400, promiseUsers: dataUsers, isPromiseAchievement: isDataAchievment, promisePanalty: dataPromisePanalty, promiseId: dataPromiseId)
            
            promise.append(newPromise)
        }
        return promise
    }
    
}
