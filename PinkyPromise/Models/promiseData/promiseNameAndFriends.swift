//
//  promiseNameAndFriends.swift
//  PinkyPromise
//
//  Created by apple on 2020/01/29.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import Foundation

struct promiseDataAndFriendsUID {
    var promiseName: String!
    var promiseId: String!
    var friendsUid: Array<String>!
}

struct promiseNameAndFriendsName {
    var promiseName: String!
    var promiseId: String!
    var friendsName: Array<String>!
}

struct promiseDetail {//선영쿤이 받을 데이터
    var promiseName: String!//약속이름
    var promiseDay: Int!//약속 기간 -> 약속시작일부터 약속종료일 뺀값
    var promiseDaySinceStart: Int!//현재 며칠짼지 약속시작일부터 오늘까지 뺀값
    var friendsNameList: Array<String>!// 약속 이름 리스트
    var friendsDegree: [[Int]]!//친구의 진행정도
}
