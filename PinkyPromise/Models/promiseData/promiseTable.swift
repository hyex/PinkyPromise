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
    private(set) var promiseAchievement: Double!
    private(set) var promiseUsers: Array<String>!
    private(set) var isPromiseAchievement: Bool!
    private(set) var promisePanalty: String!
    
    init(promiseName: String
        ,isPromiseAlarm: Bool
        ,promiseStartTime: Date
        ,promiseEndTime: Date
        ,promiseColor: String
        ,promiseAlarmContent: String
        ,promiseIcon: String
        ,promiseAchievement: Double
        ,promiseUsers: Array<String>!
        ,isPromiseAchievement: Bool
        ,promisePanalty: String) {
        self.promiseIcon = promiseIcon
        self.promiseName = promiseName
        self.promiseColor = promiseColor
        self.promiseStartTime = promiseStartTime
        self.promiseEndTime = promiseEndTime
        self.promiseAchievement = promiseAchievement
        self.isPromiseAlarm = isPromiseAlarm
        self.promiseAlarmContent = promiseAlarmContent
        self.promiseUsers = promiseUsers
        self.isPromiseAchievement = isPromiseAchievement
        self.promisePanalty = promisePanalty
    }
    
    class func parseData(snapShot: QuerySnapshot?) -> [PromiseTable] {
        var promise = [PromiseTable]()
        
        guard let snap = snapShot else { return promise }
        for document in snap.documents {
            let data = document.data()
            
            let dataName = data[PROMISENAME] as? String ?? "Anonymous"
            let isDataAlarm = data[ISPROMISEALARM] as? Bool ?? false
            let dataAlarmContent = data[PROMISEALARMCONTENT] as? String ?? "Nothing"
            let dataStartTime = data[PROMISESTARTTIME] as? Date ?? Date()
            let dataEndTime = data[PROMISEENDTIME] as? Date ?? Date()
            let dataColor = data[PROMISECOLOR] as? String ?? "not given color"
            let dataIcon = data[PROMISEICON] as? String ?? "Nothing Icon"
            let dataUsers = data[PROMISEUSERS] as? Array<String> ?? []
            let dataAchievement = data[PROMISEACHIEVEMENT] as? Double ?? 0.0
            let isDataAchievment = data[ISPROMISEACHIEVEMENT] as? Bool ?? false
            let dataPromisePanalty = data[PROMSISEPANALTY] as? String ?? "not given coler"
            
            let newPromise = PromiseTable(promiseName: dataName, isPromiseAlarm: isDataAlarm, promiseStartTime: dataStartTime, promiseEndTime: dataEndTime, promiseColor: dataColor, promiseAlarmContent: dataAlarmContent, promiseIcon: dataIcon, promiseAchievement: dataAchievement, promiseUsers: dataUsers, isPromiseAchievement: isDataAchievment, promisePanalty: dataPromisePanalty)
            
            promise.append(newPromise)
        }
        return promise
    }
}
