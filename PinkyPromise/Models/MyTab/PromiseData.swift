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
    let promiseStartDate: Date
    let promiseEndDate: Date
//    let promisedIcon: String // UIImage cannot codable. search later.
//    let promiseAlarm: String
    let promiseAchievement: Int
    
    enum CodingKeys: String, CodingKey {
//        case promiseId = "promiseId"
        case promiseName = "promiseName"
        case promiseStartDate = "promiseStartDate"
        case promiseEndDate = "promiseEndDate"
//        case promisedIcon = "promisedIcon"
//        case promiseAlarm = "promiseAlarm"
        case promiseAchievement = "promiseAchievement"
    }
    
}
