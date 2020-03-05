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
    private(set) var userCode: Int!
    private(set) var documentId: String!
    
    init(userName: String, userFriends: Array<String>, userId: String, userImage: String, userCode: Int, documentId: String) {
        self.userName = userName
        self.userFriends = userFriends
        self.userId = userId
        self.userImage = userImage
        self.userCode = userCode
        self.documentId = documentId
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
            let datauserCode = data[USERCODE] as? Int ?? Int.random(in: 100000...999999)
            let datadocumentId = document.documentID
            let newdatauser = PromiseUser(userName: datauser, userFriends: datauserFriends, userId: datauserId, userImage: datauserImage, userCode: datauserCode, documentId: datadocumentId)
            promiseuser.append(newdatauser)
        }
        
        return promiseuser
    }
    
    class func parseDouc(snapShot: DocumentSnapshot?) -> [PromiseUser] {
        var promiseuser = [PromiseUser]()
        
        guard let snap = snapShot else { return promiseuser }
        
        let data = snap.data()
        let datauser = data![USERNAME] as? String ?? "Anonymous"
        let datauserFriends = data![USERFRIENDS] as? Array<String> ?? []
        let datauserId = data![USERID] as? String ?? "nil"
        let datauserImage = data![USERIMAGE] as? String ?? "404"
        let datauserCode = data![USERCODE] as? Int ?? Int.random(in: 100000...999999)
        let datadocumentId = snap.documentID
        let newdatauser = PromiseUser(userName: datauser, userFriends: datauserFriends, userId: datauserId, userImage: datauserImage, userCode: datauserCode, documentId: datadocumentId)
        promiseuser.append(newdatauser)
        
        return promiseuser
    }
    
}
