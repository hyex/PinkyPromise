//
//  PromiseData.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/18/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import Foundation
import UIKit

struct PromiseListResponse: Codable {
    let status : Int
    let message : String
    let data : [PromiseData]
}

struct PromiseData: Codable {
    
//    let promiseId: Int
    let promiseName: String
    let promiseStartTime: Date
    let promiseEndTime: Date
    let promiseColor: String
//    let promisedIcon: String // UIImage cannot codable. search later.
//    let isPromiseAlarm: Bool
//    let promiseAlarmContent : String
    let promiseAchievement: Int
//    let users: [user] or [String] or [Int]
    
    enum CodingKeys: String, CodingKey {
//        case promiseId = "promiseId"
        case promiseName = "promiseName"
        case promiseStartTime = "promiseStartDate"
        case promiseEndTime = "promiseEndDate"
        case promiseColor = "promiseColor"
//        case promisedIcon = "promisedIcon"
//        case promiseAlarm = "promiseAlarm"
        case promiseAchievement = "promiseAchievement"
    }
    
}

