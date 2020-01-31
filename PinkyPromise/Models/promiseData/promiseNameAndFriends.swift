//
//  promiseNameAndFriends.swift
//  PinkyPromise
//
//  Created by apple on 2020/01/29.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import Foundation

//getPromiseNameAndFriendsName
struct promiseNameAndFriendsName {
    var promiseName: String!//약속 명
    var promiseId: String!//
    var friendsName: Array<String>!//로그인 유저가 함께 약속중인 친구들 이름
}

struct promiseDetailjunior1 {
    var promiseName: String!//약속이름
    var promiseDay: Double!//약속 기간 -> 약속시작일부터 약속종료일 뺀값
    var promiseDaySinceStart: Double!//현재 며칠짼지 약속시작일부터 오늘까지 뺀값
    var friendsUIDList: Array<String>!// 약속 이름 리스트
}

struct promiseDetailjunior2 {
    var promiseName: String!//약속이름
    var promiseDay: Double!//약속 기간 -> 약속시작일부터 약속종료일 뺀값
    var promiseDaySinceStart: Double!//현재 며칠짼지 약속시작일부터 오늘까지 뺀값
    var friendsName: Array<String>!// 약속 이름 리스트
    var friendsImage: String!
}

struct promiseDetail {//선영쿤이 받을 데이터
    var promiseName: String!//약속이름
    var promiseDay: Double!//약속 기간 -> 약속시작일부터 약속종료일 뺀값
    var promiseDaySinceStart: Double!//현재 며칠짼지 약속시작일부터 오늘까지 뺀값
    var friendsDetail: [promiseDetailChild]
}

struct promiseDetailChild {
    var friendName: String!
    var friendImage: String!
    var friendDegree: Array<Int>!
}
