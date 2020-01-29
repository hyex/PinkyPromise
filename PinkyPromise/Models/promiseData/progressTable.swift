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
    private(set) var progressDay: Date!
    private(set) var progressDegree: Int!
    private(set) var promiseId: String!
    private(set) var userId: String!
    
    init(progressDay: Date, progressDegree: Int, promiseId: String, userId: String) {
        self.progressDay = progressDay
        self.progressDegree = progressDegree
        self.promiseId = promiseId
        self.userId = userId
    }
    
    class func parseData(snapShot: QuerySnapshot?) -> [ProgressTable] {
        var progressTable = [ProgressTable]()
        
        guard let snap = snapShot else { return progressTable }
        for document in snap.documents {
            let data = document.data()
            
            let dataProgressDay = data[PROGRESSDAY] as? Timestamp ?? Timestamp()
            let dataProgressDaytoDate = dataProgressDay.dateValue()
            let dataProgressDegree = data[PROGRESSDEGREE] as? Int ?? 0
            let dataPromiseId = data[PROMISEID] as? String ?? "nil"
            let datauserId = data[USERID] as? String ?? "nil"
            
            let newdatauser = ProgressTable(progressDay: dataProgressDaytoDate + 32400, progressDegree: dataProgressDegree, promiseId: dataPromiseId, userId: datauserId)
            progressTable.append(newdatauser)
        }
        
        return progressTable
    }
}
