//
//  promiseNameAndFriends.swift
//  PinkyPromise
//
//  Created by apple on 2020/01/29.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import Foundation

struct tempStruct {
    var promiseName: String!
    var friendsUid: Array<String>!
}

class promiseNameAndFriends {
    var promiseName: String!
    var friendsName: Array<String>!
    
    init(promiseName: String, friendsName: Array<String>) {
        self.promiseName = promiseName
        self.friendsName = friendsName
    }
}
