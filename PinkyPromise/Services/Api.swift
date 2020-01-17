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
//    dateFormatter.locale = Locale(identifier: "ko_KR")
//    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
    
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
    
    
//    func allPromise(completion: @escaping ([PromiseData]) -> Void) {
//        //}, onError: @escaping (Error) -> Void) {
//        let result = [
//            PromiseData(promiseName: "10시에 기상하기",
//                        promiseStartDate: dateFormatter.date(from:"2020-01-03 10:00"),
//                        promiseEndDate: dateFormatter.date(from:"2020-01-14 10:00"),
//                        promiseAchievement: 3),
//            PromiseData(promiseName: "4시에는 쿨쿨하기",
//                        promiseStartDate: dateFormatter.date(from:"2020-01-02 13:00"),
//                        promiseEndDate: dateFormatter.date(from:"2020-01-05 14:00"),
//                        promiseAchievement: 4),
//            
//        ]
//        completion(result)
//    }
}
