//
//  promiseUsers.swift
//  PinkyPromise
//
//  Created by apple on 2020/01/19.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import Foundation
import Firebase

class ProgressTable {
    private(set) var progressDegree: Array<Int>!
    private(set) var promiseId: String!
    private(set) var userId: String!
    private(set) var progressId: String!
    
    init(progressDegree: Array<Int>, promiseId: String, userId: String, progressId: String) {
        self.progressDegree = progressDegree
        self.promiseId = promiseId
        self.userId = userId
        self.promiseId = progressId
    }
    
    class func parseData(snapShot: QuerySnapshot?) -> [ProgressTable] {
        var progressTable = [ProgressTable]()
        
        guard let snap = snapShot else { return progressTable }
        for document in snap.documents {
            let data = document.data()
            
            let dataProgressDegree = data[PROGRESSDEGREE] as? Array<Int> ?? []
            let dataPromiseId = data[PROMISEID] as? String ?? "nil"
            let datauserId = data[USERID] as? String ?? "nil"
            let dataProgressId = document.documentID
            
            let newdatauser = ProgressTable(progressDegree: dataProgressDegree, promiseId: dataPromiseId, userId: datauserId, progressId: dataProgressId)
            
            progressTable.append(newdatauser)
        }
        
        return progressTable
    }
}
