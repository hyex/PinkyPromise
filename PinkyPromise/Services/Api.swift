//
//  Api.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/14/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import Foundation


class MyApi: NSObject {
    
    static let shared = MyApi()
    
    let dateFormatter = DateFormatter()

    // Api 예시
    func allMenu(completion: @escaping ([MoreTableData]) -> Void) { //}, onError: @escaping (Error) -> Void) {
        let result = [
            MoreTableData(title: "예제1"),
            MoreTableData(title: "예제2"),
            MoreTableData(title: "예제3"),

        ]
        completion(result)
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
                        promiseStartTime: dateFormatter.date(from:"2020-01-03 10:00") ?? defaultDate,
                        promiseEndTime: dateFormatter.date(from:"2020-01-14 10:00") ?? defaultDate,
                        promiseColor: "red",
                        promiseAchievement: 3),
            PromiseData(promiseName: "4시에는 쿨쿨하기",
                        promiseStartTime: dateFormatter.date(from:"2020-01-02 13:00") ?? defaultDate,
                        promiseEndTime: dateFormatter.date(from:"2020-01-05 14:00") ?? defaultDate,
                        promiseColor: "blue",
                        promiseAchievement: 2),

        ]
        completion(result)
        
        /**
             
         //    let promiseList: [MyPromise] = [MyPromise(promiseName: "1시간 독서", promiseStory: "1시간 독서하기", pormiseProgress: 3.0 ),
         //                                    MyPromise(promiseName: "2시간 운동", promiseStory: "2시간 운동하기", pormiseProgress: 10.0),
         //                                    MyPromise(promiseName: "2시간 동방", promiseStory: "2시간 누워있기", pormiseProgress: 0.0),
         //                                    MyPromise(promiseName: "2시간 공부", promiseStory: "2시간 공부하기", pormiseProgress: 7.0),
         //                                    MyPromise(promiseName: "2시간 식사", promiseStory: "2시간 식사하기", pormiseProgress: 8.0),
         //                                 MyPromise(promiseName: "2시간 취침", promiseStory: "2시간 취침하기", pormiseProgress: 9.0),
         //                                 MyPromise(promiseName: "2시간 기상", promiseStory: "2시간 기상하기", pormiseProgress: 3.0),
         //                                 MyPromise(promiseName: "2시간 체조", promiseStory: "2시간 체조하기", pormiseProgress: 1.0)]
         //
         */
    }
}
