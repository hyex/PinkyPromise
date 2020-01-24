//
//  promiseUsers.swift
//  PinkyPromise
//
//  Created by apple on 2020/01/19.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import Foundation
import Firebase

class PromiseUser {
    private(set) var userName: String!
    private(set) var userFriends: Array<String>!
    private(set) var userId: String!
    private(set) var userImage: String!
    init(userName: String, userFriends: Array<String>, userId: String, userImage: String) {
        self.userName = userName
        self.userFriends = userFriends
        self.userId = userId
        self.userImage = userImage
    }
    
    class func parseData(snapShot: QuerySnapshot?) -> [PromiseUser] {
        var promiseuser = [PromiseUser]()
        
        guard let snap = snapShot else { return promiseuser }
        for document in snap.documents {
            let data = document.data()
            let datauser = data[USERNAME] as? String ?? "Anonymous"
            let datauserFriends = data[USERFRIENDS] as? Array<String> ?? []
            let datauserId = data[USERID] as? String ?? "nil"
            let datauserImage = data[USERIMAGE] as? String ?? "404"
            let newdatauser = PromiseUser(userName: datauser, userFriends: datauserFriends, userId: datauserId, userImage: datauserImage)
            promiseuser.append(newdatauser)
        }
        
        return promiseuser
    }
}
