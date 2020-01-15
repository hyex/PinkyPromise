//
//  MyPromise.swift
//  PinkyPromise
//
//  Created by apple on 2020/01/14.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import Foundation

struct MyPromise: Codable {
    var promiseName: String
    var promiseStory: String
    var pormiseProgress: Double// 약속 진행 상황 알려주는 진행률
}
