//
//  Api.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/14/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

/* 기본적으로 Auth.auth().currentuser 유저의 uid가 포함하고 있는 함수들만 있게함*/

class MyApi: NSObject {
    
    static let shared = MyApi()
    
    fileprivate let promiseCollectionRef = Firestore.firestore().collection(PROMISETABLEREF)
    fileprivate let userCollectionRef = Firestore.firestore().collection(PROMISEUSERREF)
    fileprivate let progressCollectionRef = Firestore.firestore().collection(PROGRESSTABLEREF)
    
    var promiseListner: ListenerRegistration!
    
    let dateFormatter = DateFormatter()
    
    func fireStoreSetting() {
        let store = Firestore.firestore()
        
        let setting = FirestoreSettings()
        setting.isPersistenceEnabled = true
        setting.cacheSizeBytes = FirestoreCacheSizeUnlimited
        
        store.settings = setting
    }
    
    // Api 예시
    func allMore(completion: ([MoreTableData]) -> Void) { //}, onError: @escaping (Error) -> Void) {
        let result = [
            MoreTableData(title: "내 정보"),
            MoreTableData(title: "내 친구"),
            MoreTableData(title: "내 코드"),
        ]
        completion(result)
    }
    
    //유저 데이터가 업데이트될때마다 실행되며 업데이트된 데이터를 반환해줌, 클로저 사용
    func getUserUpdate(completion: @escaping ([PromiseUser]) -> Void) {
        var result = [PromiseUser]()
        promiseListner = userCollectionRef.whereField(USERID, isEqualTo: FirebaseUserService.currentUserID).addSnapshotListener({ (snapShot, error) in
            if let err = error {
                debugPrint(err)
            } else {
                result = PromiseUser.parseData(snapShot: snapShot)
                completion(result)
            }
        })
    }
    
    //유저 데이터를 반환해줌
    func getUserData(completion: @escaping ([PromiseUser]) -> Void) {
        var result = [PromiseUser]()
        userCollectionRef.whereField(USERID, isEqualTo: FirebaseUserService.currentUserID).getDocuments { (sanpShot, err) in
            if let err = err {
                debugPrint(err)
            }else {
                result = PromiseUser.parseData(snapShot: sanpShot)
                completion(result)
            }
        }
    }
    
    //UID에 맞는 유저 이름을 반환해줌
    func getUserNameWithUID(id: String, completion: @escaping (String) -> Void) {
        userCollectionRef.whereField(USERID, isEqualTo: id).getDocuments { (sanpShot, err) in
            if let err = err {
                debugPrint(err)
            }else {
                let result = PromiseUser.parseData(snapShot: sanpShot)
                completion(result[0].userName)
            }
        }
    }
    
    //유저의 친구들의 promiseUser들 가져온다.
    func getUsersFriendsData(completion: @escaping ([PromiseUser]) -> Void) {
        userCollectionRef.whereField(USERID, isEqualTo: FirebaseUserService.currentUserID).getDocuments { (snapShot, error) in
            if let err = error {
                debugPrint(err.localizedDescription)
            } else {
                let tempResult = PromiseUser.parseData(snapShot: snapShot)
                var temp = [PromiseUser]()
                var check1 = 0
                
                if tempResult.count > 0 {
                    for douc in tempResult[0].userFriends {
                        self.getUserDataWithUID(id: douc) { (result) in
                            temp.append(result)
                            check1 += 1
                            if tempResult[0].userFriends.count <= check1 {
                                completion(temp)
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    //UID에 맞는 유저 데이터를 반환해줌
    func getUserDataWithUID(id: String, completion: @escaping (PromiseUser) -> Void) {
        var result = [PromiseUser]()
        userCollectionRef.whereField(USERID, isEqualTo: id).getDocuments { (sanpShot, err) in
            if let err = err {
                debugPrint(err)
            }else {
                result = PromiseUser.parseData(snapShot: sanpShot)
                let result2 = result[result.startIndex]
                completion(result2)
            }
        }
    }
    
    //약속 아이디를 가지고 약속한 친구의 이름들을 반환하는 함수
    func getPromiseFriendsNameWithPID(promiseID: String, completion: @escaping ([String]) -> Void) {
        promiseCollectionRef.whereField(PROMISEID, isEqualTo: promiseID).getDocuments { (snapsHot, error ) in
            if let err = error {
                debugPrint(err.localizedDescription)
            } else {
                let tempResult = PromiseTable.parseData(snapShot: snapsHot)
                var temp = [String]()
                
                let usersNotMe = tempResult[0].promiseUsers.filter { $0 != FirebaseUserService.currentUserID }
                
                for douc in usersNotMe {
                    self.getUserNameWithUID(id: douc) { (result) in
                        temp.append(result)
                        if temp.count == usersNotMe.count {
                            completion(temp)
                        }
                    }
                }
                
            }
        }
    }
    
    //약속 데이터를 반환// 내가 포함되어 있는 녀석들만
    func getPromiseData(completion: @escaping ([PromiseTable]) -> Void) {
        var result = [PromiseTable]()
        promiseCollectionRef.whereField(PROMISEUSERS, arrayContains: FirebaseUserService.currentUserID).getDocuments { (sanpShot, err) in
            if let err = err {
                debugPrint(err)
            }else {
                result = PromiseTable.parseData(snapShot: sanpShot)
                completion(result)
            }
        }
    }
    
    //이미 끝난 약속 데이터만 반환하는 함수
    func getCompletedPromiseData(completion: @escaping ([PromiseTable]) -> Void) {
        let result = Timestamp()
        
        promiseCollectionRef.whereField(PROMISEUSERS, arrayContains: FirebaseUserService.currentUserID).whereField(PROMISEENDTIME, isLessThan: result).getDocuments { (snapShot, error) in
            if let err = error {
                debugPrint(err.localizedDescription)
            } else {
                let tempResult = PromiseTable.parseData(snapShot: snapShot)
                self.getPerfectCompletedPromiseData(promises: tempResult, completion: { result in
                    completion(result)
                })
            }
        }
        
    }
    
    //끝난 약속 데이터를 인풋으로, 이중에서 프로그레스 배열이 모두 4인 경우만 약속 반환
    func getPerfectCompletedPromiseData(promises: [PromiseTable], completion: @escaping ([PromiseTable]) -> Void) {
        var result = [PromiseTable]()
        
        var countcheck = 0
        for douc in promises {
            progressCollectionRef.whereField(USERID, isEqualTo: FirebaseUserService.currentUserID).whereField(PROMISEID, isEqualTo: douc.promiseId).getDocuments { (snapShot, error) in
                if let err = error {
                    debugPrint(err.localizedDescription)
                } else {
                    let tempResult = ProgressTable.parseData(snapShot: snapShot)
                    
                    if tempResult.count > 0 {
                        let check4 = tempResult[0].progressDegree.contains { $0 < 4 }
                        
                        if check4 == false {
                            result.append(douc)
                            if promises.count <= countcheck {
                                completion(result)
                            }
                        }
                    }
                }
            }
            countcheck += 1
        }
    }
    
    //func getPromiseAndProgress()
    
    
    //약속 데이터가 업데이트되면 실행되며 업데이트되는 데이터를 받아줌
    func getPromiseUpdate(completion: @escaping ([PromiseTable]) -> Void) {
        var result = [PromiseTable]()
        
        //        promiseListner = promiseCollectionRef.order(by: PROMISEACHIEVEMENT, descending: true).addSnapshotListener({ (snapShot, error) in
        promiseListner = promiseCollectionRef.whereField(PROMISEUSERS, arrayContains: FirebaseUserService.currentUserID).addSnapshotListener({ (snapShot, error) in
            if let err = error {
                debugPrint(err)
            } else {
                result = PromiseTable.parseData(snapShot: snapShot)
                completion(result)
            }
        })
    }
    
    //프로그레스테이블의 정보 반환 약속 id를 반환하면 
    func getProgressDataWithPromiseId(promiseid: String, completion: @escaping ([ProgressTable]) -> Void ){
        var result: [ProgressTable] = [] //[ProgressTable]()]
        //        var result: [ProgressTable]? = nil
        progressCollectionRef.whereField(USERID, isEqualTo: FirebaseUserService.currentUserID).whereField(PROMISEID, isEqualTo: promiseid).getDocuments { (snapShot, error) in
            if let err = error {
                debugPrint("debug print \(err)")
            } else {
                result = ProgressTable.parseData(snapShot: snapShot)
                completion(result)
                
            }
        }
    }
    
    //프로그레스테이블에 원하는 유저의 uid를 인풋으로 그 유저의 프로그레스 정보를 알 수 있다
    func getProgressDataWithUid(userid: String, completion: @escaping ([ProgressTable]) -> Void ) {
        var result = [ProgressTable]()
        progressCollectionRef.whereField(USERID, isEqualTo: userid).getDocuments { (snapShot, error) in
            
            if let err = error {
                debugPrint("debug print \(err)")
            } else {
                result = ProgressTable.parseData(snapShot: snapShot)
                completion(result)
            }
            
        }
    }
    
    //프로그레스테이블의 유저의 정보를 알 수 있다.
    func getAllProgressData(completion: @escaping ([ProgressTable]) -> Void ){
        var result = [ProgressTable]()
        progressCollectionRef.whereField(USERID, isEqualTo: FirebaseUserService.currentUserID).getDocuments { (snapShot, error) in
            if let err = error {
                debugPrint("debug print \(err)")
            } else {
                result = ProgressTable.parseData(snapShot: snapShot)
                completion(result)
            }
        }
    }
    
    //오늘을 기준으로 10일 이전 약속들을 [PromiseTable]을 하나의 배열 요소로 가지는 배열
    //업데이트됨
    func getPromiseData10ToNow(completion: @escaping ([DayAndPromise]) -> Void ) {
        let result = Timestamp()
        let now = Date()
        
        promiseCollectionRef.whereField(PROMISEUSERS, arrayContains: FirebaseUserService.currentUserID).whereField(PROMISEENDTIME, isGreaterThan: now).order(by: PROMISEENDTIME).getDocuments { (snapShot, error) in
            if let err = error {
                debugPrint(err.localizedDescription)
            } else {
                let tempResult = PromiseTable.parseData(snapShot: snapShot)
                var temp1 = [DayAndPromise]()
                
                //10일 전부터 10일 후까지
                for i in stride(from: now.timeIntervalSince1970 - 864000, through: now.timeIntervalSince1970 + 864000, by: 86400) {
                    var temp2 = [PromiseTable]()
                    
                    for douc in tempResult {
                        if (i >= douc.promiseStartTime.timeIntervalSince1970) && (i <= douc.promiseEndTime.timeIntervalSince1970) {
                            temp2.append(douc)
                        }
                    }
                    
                    let temp3 = DayAndPromise(Day: Date(timeIntervalSince1970: i), promiseData: temp2)
                    temp1.append(temp3)
                }
                completion(temp1)
            }
        }
    }
    
    //오늘을 기준으로 약속이 끝날 때까지의 날짜별 데이터
    func getPromiseDataSorted(completion: @escaping ([[PromiseTable]]) -> Void ) {
        
        let result = Timestamp()
        let now = Date()
        let tommorow = Date(timeIntervalSince1970: now.timeIntervalSince1970 + 60*60*24)
        
        promiseCollectionRef.whereField(PROMISEUSERS, arrayContains: FirebaseUserService.currentUserID).whereField(PROMISEENDTIME, isGreaterThan: result).order(by: PROMISEENDTIME).getDocuments { (snapShot, error) in
            if let err = error {
                debugPrint(err.localizedDescription)
            } else {
                let tempResult = PromiseTable.parseData(snapShot: snapShot)
                
                let MaxTime = tempResult.count
                if MaxTime > 0 {
                    let maxTimeDate = tempResult[MaxTime].promiseEndTime
                    
                    var temp1 = [[PromiseTable]]()
                    
                    for i in stride(from: now.timeIntervalSince1970, through: maxTimeDate.timeIntervalSince1970, by: 60*60*24) {
                        //i는 하루하루의 타임스탬프
                        
                        var temp2 = [PromiseTable]()
                        
                        for douc in tempResult {
                            if (i > douc.promiseStartTime.timeIntervalSince1970) && (i < douc.promiseEndTime.timeIntervalSince1970) {
                                temp2.append(douc)
                            }
                        }
                        temp1.append(temp2)
                    }
                    
                    completion(temp1)
                }
            }
        }
    }
    
    //선영쿤이 요청한 함수 -> friendTab에 들어갈 데이터
    func getPromiseNameAndFriendsName(completion: @escaping ([promiseNameAndFriendsName]) -> Void) {
        
        promiseCollectionRef.whereField(PROMISEUSERS, arrayContains: FirebaseUserService.currentUserID).getDocuments { (snapShot, error) in
            if let err = error {
                debugPrint(err.localizedDescription)
            }else {
                let tempResult = PromiseTable.parseData(snapShot: snapShot)
                var result1 = [promiseNameAndFriendsName]()
                var check = 0
                for douc in tempResult {
                    let FriendsList = douc.promiseUsers.filter { $0 != FirebaseUserService.currentUserID }
                    
                    let temp = promiseNameAndFriendsName(promiseName: douc.promiseName, promiseId: douc.promiseId, FirstuserImage: douc.promiseName, friendsName: FriendsList)
                    
                    if FriendsList.count == 0 {//친구가 없으면 패스하고 check에 1을 더해준다.
                        check += 1
                    } else {
                        self.getFriendsName(tempTable: temp) { (result) in
                            result1.append(result)
                            if result1.count + check >= tempResult.count {
                                completion(result1)
                            }
                        }
                    }
                }
            }
        }
    }
    
    //getPromiseNameAndFriendsName의 부속함수, 약속테이블의 사용자의 친구들의 이름을 반환함
    func getFriendsName(tempTable: promiseNameAndFriendsName, completion: @escaping (promiseNameAndFriendsName) -> Void ){
        
        var temp2 = [String]()
        let temp4 = tempTable.friendsName.sorted()
        for douc in temp4 {
            self.getUserNameWithUID(id: douc) { (result) in
                temp2.append(result)
                if temp2.count == tempTable.friendsName.count {
                    let temp3 = promiseNameAndFriendsName(promiseName: tempTable.promiseName, promiseId: tempTable.promiseId, FirstuserImage: temp4[0], friendsName: temp2.sorted())
                    completion(temp3)
                }
            }
        }
    }
    
    //선영쿤이 요청한 detailView 진행중인 약속에 한해 들어간다.
    //이거 쿼리 물어봐야함 도대체 왜 세개하면 invalid라고 뜰
    func getDataforDetailViewjr1(promiseID: String, completion: @escaping (promiseDetail) -> Void) {
        promiseCollectionRef.whereField(PROMISEID, isEqualTo: promiseID).whereField(PROMISEENDTIME, isGreaterThanOrEqualTo: Timestamp()).getDocuments { (snapshot, error) in
            if let err = error {
                debugPrint(err.localizedDescription)
            } else {
                let result = PromiseTable.parseData(snapShot: snapshot)
                
                if result.count > 0 {
                    let promiseDay = Double( (result[0].promiseEndTime.timeIntervalSince1970 - result[0].promiseStartTime.timeIntervalSince1970) / 86400)
                    
                    let promiseDaysinceToday = Double( ( Date().timeIntervalSince1970 - result[0].promiseStartTime.timeIntervalSince1970 ) / 86400 )
                    
                    let tempUsers = result[0].promiseUsers.filter { $0 != FirebaseUserService.currentUserID }
                    
                    let temp = promiseDetailjunior1(promiseName: result[0].promiseName, promiseDay: promiseDay, promiseDaySinceStart: promiseDaysinceToday, friendsUIDList: tempUsers)
                    
                    //completion(temp)
                    
                    self.getDataForDetailViewjr2(detailData1: temp) { (result2) in
                        completion(result2)
                    }
                }
            }
        }
    }
    
    func getDataForDetailViewjr2(detailData1: promiseDetailjunior1, completion: @escaping (promiseDetail) -> Void) {
        
        var temp3 = [promiseDetail]()
        
        var temp4 = [promiseDetailChild]()
        
        for douc in detailData1.friendsUIDList {
            self.getUserDataWithUID(id: douc) { (result3) in
                
                self.getProgressDataWithUid(userid: douc) { (result4) in
                    
                    var temp6 = Array<Int>(repeating: 0, count: 5)
                    
                    if result4.count > 0 {
                        for i in result4[0].progressDegree {
                            switch i {
                            case 0:
                                temp6[i] += 1
                            case 1:
                                temp6[i] += 1
                            case 2:
                                temp6[i] += 1
                            case 3:
                                temp6[i] += 1
                            case 4:
                                temp6[i] += 1
                            case -1:
                                print("")
                            //-1은 안한거다.
                            default:
                                print("cuase default at getDataForDetailViewjr2")
                            }
                        }
                    } 
                    
                    let zek = promiseDetailChild(friendName: result3.userName, friendImage: result3.userImage, friendDegree: temp6)
                    temp4.append(zek)
                    
                    if temp4.count == detailData1.friendsUIDList.count {
                        
                        completion(promiseDetail(promiseName: detailData1.promiseName, promiseDay: detailData1.promiseDay, promiseDaySinceStart: detailData1.promiseDaySinceStart, friendsDetail: temp4))
                        
                    }
                }
            }
        }
    }
    
    
    //오늘을 기준으로 끝나지 않은 약속들만 반환
    func getPromiseDataSinceToday(completion: @escaping ([PromiseTable]) -> Void) {
        let result = Timestamp()
        
        promiseCollectionRef.whereField(PROMISEUSERS, arrayContains: FirebaseUserService.currentUserID).whereField(PROMISEENDTIME, isGreaterThanOrEqualTo: result).getDocuments { (snapShot, error) in
            if let err = error {
                debugPrint(err.localizedDescription)
            } else {
                let tempResult = PromiseTable.parseData(snapShot: snapShot)
                completion(tempResult)
            }
        }
    }
    
    //의정쿤이 요청한 함수 졸라게 어려붐 펔큉 극강빌런임
    func getMothlyDataWithCurrentMonth(completion: @escaping ([PromiseAndProgress]) -> Void) {
        
        let days = self.getTotalDate()//이번 달의 날짜 수 31일
        
        let cal = Calendar.current
        let components = cal.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: Date())
        
        let todayMonth = components.month //이번 달이 몇번째 달인지
        let todayDay = components.day // 오늘이 며칠째인지
        
        let firstDay = Date(timeIntervalSince1970: Date().timeIntervalSince1970 - Double(86400 * (todayDay! - 1)) + 32400)//이번달의 첫번째 날
        
        let calendar = Calendar(identifier: .gregorian)
        
        let comps = DateComponents(calendar:calendar, year:components.year, month:components.month, day:1) //그 달 1일
        
        //components.day => 오늘날짜
        var temp = [PromiseAndProgress]()
        var check = 1
        for i in 0 ..< days {//이번달 일수만큼
            
            var firstDayPlusi = Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(i * 86400) )
            
            promiseCollectionRef.whereField(PROMISEUSERS, arrayContains: FirebaseUserService.currentUserID).whereField(PROMISEENDTIME, isGreaterThanOrEqualTo: firstDay ).getDocuments { (snapShot, error ) in
                
                if let err = error {
                    debugPrint(err.localizedDescription)
                } else {
                    
                    let tempResult1 = PromiseTable.parseData(snapShot: snapShot)
                    
                    let tempResult2 = tempResult1.filter { $0.promiseStartTime.timeIntervalSince1970 <= firstDayPlusi.timeIntervalSince1970 && $0.promiseEndTime.timeIntervalSince1970 >= firstDayPlusi.timeIntervalSince1970 }
                    
                    self.getMothlyDataWithCurrentMonth2(day: firstDayPlusi, promiseData: tempResult2) { (result2) in
                        //result2는 PromiseAndProgress객체임
                        
                        if result2.promiseData.count > 0 {
                            temp.append(result2)
                        } else {
                            let tempresult3 = PromiseAndProgress(Day: firstDayPlusi, promiseData: [], progressData: [])
                            temp.append(tempresult3)
                        }
                        
                        if temp.count >= days {
                            completion(temp)
                        }
                        
                    }
                    
                    
                }
            }
        }
    }
    
    func getMothlyDataWithCurrentMonth2(day: Date, promiseData: [PromiseTable], completion: @escaping (PromiseAndProgress) -> Void ) {
        
        var temp = [ProgressTable]()
        for douc in promiseData {
            
            progressCollectionRef.whereField(PROMISEID, isEqualTo: douc.promiseId).whereField(USERID, isEqualTo: FirebaseUserService.currentUserID).getDocuments { (snapShot, error) in
                if let err = error {
                    print("this is err..1 \(err.localizedDescription)")
                } else {
                    let temp2 = ProgressTable.parseData(snapShot: snapShot)
                    
                    if temp2.count > 0 {
                        temp.append(temp2[0])
                    } else {
                        let tmmppg = ProgressTable(progressDegree: [], promiseId: douc.promiseId, userId: FirebaseUserService.currentUserID!, progressId: MyApi.shared.randomNonceString())
                        temp.append(tmmppg)
                    }
                    
                    if temp.count >= promiseData.count {
                        completion(PromiseAndProgress(Day: day, promiseData: promiseData, progressData: temp))
                    }
                }
                
            }
        }
        
    }
    
    //제발.. 오늘을 기준으로 이번 달의 날짜를 반환
    func getTotalDate() -> Int{
        // choose the month and year you want to look
        let date = Date()
        let calendar = Calendar.current
        let componentsYear = calendar.dateComponents([.year], from: date)
        let year = componentsYear.year
        let componentsMonth = calendar.dateComponents([.month], from: date)
        let month = componentsMonth.month
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        
        let datez = calendar.date(from: dateComponents)
        // change .month into .year to see the days available in the year
        let interval = calendar.dateInterval(of: .month, for: datez!)!
        
        let days = calendar.dateComponents([.day], from: interval.start, to: interval.end).day!
        
        return days
    }
    
    //약속 데이터를 추가할 때 사용하는 함수
    func addPromiseData(_ promiseTable: PromiseTable) {
        
        Firestore.firestore().collection(PROMISETABLEREF).document(promiseTable.promiseId).setData([
            PROMISENAME : promiseTable.promiseName ?? "Anomynous",
            PROMISECOLOR: promiseTable.promiseColor ?? "nil",
            PROMISEICON: promiseTable.promiseIcon ?? "nil",
            ISPROMISEACHIEVEMENT: promiseTable.isPromiseAchievement ?? false,
            PROMISESTARTTIME: promiseTable.promiseStartTime ?? Date(),
            PROMISEENDTIME: promiseTable.promiseEndTime ?? Date(),
            PROMSISEPANALTY: promiseTable.promisePanalty ?? "nil",
            PROMISEUSERS: promiseTable.promiseUsers ?? [],
            PROMISEID: promiseTable.promiseId ?? "nil"
        ]) { error in
            if let err = error {
                debugPrint("Error adding document : \(err)")
            } else {
                print("parsing success")
            }
        }
        
    }
    
    //사용자 데이터를 추가할 때 사용하는 함수
    func addUserData(_ userTable: PromiseUser) {
        
        Firestore.firestore().collection(PROMISEUSERREF).document(userTable.userId).setData([
            USERNAME : userTable.userName ?? "Anomynous",
            USERFRIENDS: userTable.userFriends ?? [],
            USERID: userTable.userId ?? "nil",
            USERIMAGE: userTable.userImage ?? "404",
            USERCODE: userTable.userCode ?? Int.random(in: 100000...999999)
        ]) { error in
            if let err = error {
                debugPrint("Error adding document : \(err)")
            } else {
                print("this is API success")
            }
        }
    }
    
    //프로그레스테이블에 데이터 추가, addPromiseTable 직후 같은 promiseTable을 넣어준다.
    func addProgressData(_ promiseTable: PromiseTable) {
        
        let indexTime = Int(promiseTable.promiseEndTime.timeIntervalSince1970 - promiseTable.promiseStartTime.timeIntervalSince1970) / 86400
        let indexPromiseId = promiseTable.promiseId
        
        for douc in promiseTable.promiseUsers {//약속에 있는 유저 개수만큼 progressTable을 만든다.
            let temp1 = [Int](repeating: -1, count: indexTime)
            
            Firestore.firestore().collection(PROGRESSTABLEREF).addDocument( data: [
                PROGRESSDEGREE: temp1,
                PROMISEID: indexPromiseId ?? "nil",
                USERID: douc
            ]) { error in
                if let err = error {
                    debugPrint("error adding document : \(err)")
                } else {
                    print("this is API success")
                }
            }
        }
    }
    
    func addFriendWithCode(code: Int, completion: @escaping (PromiseUser?) -> Void) {
        userCollectionRef.whereField(USERCODE, isEqualTo: code).getDocuments { (snapShot, error) in
            if let err = error {
                debugPrint(err.localizedDescription)
            }else {
                let result = PromiseUser.parseData(snapShot: snapShot)
                //result는 원소가 1인 배열이거나 혹은 0인 배열
                
                if result.count > 0 {
                    //code를 가지는 사용자가 있다는 의미
                    
                    if result[0].userId != FirebaseUserService.currentUserID {
                        //본인이 아닐 경우 사용자에 친구 추가 누름
                        
                        self.getUserData { (result2) in
                            
                            var temp = result2[0].userFriends
                            
                            let tempadd = temp!.contains { $0 == (result[0].userId) }
                            
                            if tempadd == false {
                                temp?.append(result[0].userId)
                            }
                            
                            self.userCollectionRef.document(FirebaseUserService.currentUserID!).setData( [USERFRIENDS : temp], merge: true )
                            
                        }
                    }
                    
                    self.getUserDataWithUID(id: result[0].userId) { (result) in
                        completion(result)
                    }
                } else {
                    //사용자가 없다. 고로 result는 0, 빈 배열
                    completion(nil)
                }
            }
        }
    }
    
    
    //유저를 uid를 이용해서 유저를 삭제하는 함수
    func deleteUserWithUid(Uid: String) {
        //let uid = Auth.auth().currentUser!.uid
        let uid = Uid
        
        Firestore.firestore().collection(PROMISEUSERREF).whereField(USERID, isEqualTo: uid).getDocuments { (snapshot, error) in
            if let err = error {
                print("get error in delete user with uid... with \(err)")
            } else {
                for document in snapshot!.documents {
                    document.reference.delete()
                }
            }
        }
        
    }
    
    //약속을 약속 id를 사용해서 삭제하는 함수
    //약속 id는 약속 doucment id를 의미한다.
    func deletePromiseWithDocumentId(_ promiseId: String) {
        Firestore.firestore().collection(PROMISETABLEREF).document(promiseId).delete() { error in
            if let err = error {
                print("delete promise cause \(err)..")
            } else {
                print("delete promise success")
            }
        }
    }
    
    //progress를 uid를 사용해서 삭제하는함수
    func deleteProgressWithUid(Uid: String) {
        //let uid = Auth.auth().currentUser!.uid
        let uid = Uid
        
        Firestore.firestore().collection(PROGRESSTABLEREF).whereField(USERID, isEqualTo: uid).getDocuments { (snapshot, error) in
            if let err = error {
                print("delete user with uid cause \(err)...")
            } else {
                for document in snapshot!.documents {
                    document.reference.delete()
                }
            }
        }
        
    }
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if length == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        //let index = result.index(result.startIndex, offsetBy: 20)
        return String(result.prefix(20))
    }
    
    // VC file에 이렇게 사용
    //    MyApi.shared.allMenu(completion: { result in
    //               DispatchQueue.main.async {
    //                   self.moreTableList = result
    //                   self.moreTableView.reloadData()
    //               }
    //           })
    
    func allPromise(completion: @escaping ([PromiseData]) -> Void) {
        //}, onError: @escaping (Error) -> Void) {
        
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let defaultDate = Date(timeIntervalSince1970: 0)
        
        let result = [
            PromiseData(promiseName: "10시에 기상하기",
                        promiseStartTime: dateFormatter.date(from:"2020-01-18 10:00") ?? defaultDate,
                        promiseEndTime: dateFormatter.date(from:"2020-01-28 10:00") ?? defaultDate,
                        promiseColor: "green",
                        promiseAchievement: 3),
            PromiseData(promiseName: "4시에는 쿨쿨하기",
                        promiseStartTime: dateFormatter.date(from:"2020-01-20 13:00") ?? defaultDate,
                        promiseEndTime: dateFormatter.date(from:"2020-01-25 14:00") ?? defaultDate,
                        promiseColor: "lightGray",
                        promiseAchievement: 4),
            PromiseData(promiseName: "완료된 약속",
                        promiseStartTime: dateFormatter.date(from:"2020-01-25 13:00") ?? defaultDate,
                        promiseEndTime: dateFormatter.date(from:"2020-01-27 14:00") ?? defaultDate,
                        promiseColor: "purple",
                        promiseAchievement: 3),
            PromiseData(promiseName: "DARARARARA",
                        promiseStartTime: dateFormatter.date(from:"2020-01-18 10:00") ?? defaultDate,
                        promiseEndTime: dateFormatter.date(from:"2020-01-28 10:00") ?? defaultDate,
                        promiseColor: "orange",
                        promiseAchievement: 3),
            PromiseData(promiseName: "4시에는 쿨쿨하기",
                        promiseStartTime: dateFormatter.date(from:"2020-01-20 13:00") ?? defaultDate,
                        promiseEndTime: dateFormatter.date(from:"2020-01-25 14:00") ?? defaultDate,
                        promiseColor: "yellow",
                        promiseAchievement: 4),
            PromiseData(promiseName: "완료된 약속",
                        promiseStartTime: dateFormatter.date(from:"2020-01-25 13:00") ?? defaultDate,
                        promiseEndTime: dateFormatter.date(from:"2020-01-27 14:00") ?? defaultDate,
                        promiseColor: "purple",
                        promiseAchievement: 3),
            PromiseData(promiseName: "aassddff",
                        promiseStartTime: dateFormatter.date(from:"2020-01-18 10:00") ?? defaultDate,
                        promiseEndTime: dateFormatter.date(from:"2020-01-28 10:00") ?? defaultDate,
                        promiseColor: "systemPink",
                        promiseAchievement: 3),
            PromiseData(promiseName: "4시에는 쿨쿨하기",
                        promiseStartTime: dateFormatter.date(from:"2020-01-20 13:00") ?? defaultDate,
                        promiseEndTime: dateFormatter.date(from:"2020-01-25 14:00") ?? defaultDate,
                        promiseColor: "blue",
                        promiseAchievement: 4),
            PromiseData(promiseName: "완료된 약속",
                        promiseStartTime: dateFormatter.date(from:"2020-01-25 13:00") ?? defaultDate,
                        promiseEndTime: dateFormatter.date(from:"2020-01-27 14:00") ?? defaultDate,
                        promiseColor: "purple",
                        promiseAchievement: 3),
        ]
        completion(result)
        
    }
    
    
}

