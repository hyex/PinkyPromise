//
//  HomeTabMainService.swift
//  PinkyPromise
//
//  Created by SEONYOUNG LEE on 2020/02/25.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

class HomeTabMainService : NSObject {
    static let shared = HomeTabMainService()
        
        fileprivate let promiseCollectionRef = Firestore.firestore().collection(PROMISETABLEREF)
        fileprivate let userCollectionRef = Firestore.firestore().collection(PROMISEUSERREF)
        fileprivate let progressCollectionRef = Firestore.firestore().collection(PROGRESSTABLEREF)
        
        var promiseListner: ListenerRegistration!
        
        let dateFormatter = DateFormatter()
    
    //real homeTab
    func getAllHome(completion: @escaping ([PromiseAndProgress1]) -> Void){
        let days = self.getTotalDate()//이번 달의 날짜 수 31일
        
        let cal = Calendar.current
        let components = cal.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: Date())
        
        let todayDay = components.day // 오늘이 며칠째인지
        
        var firstDay = Date(timeIntervalSince1970: Date().timeIntervalSince1970 - Double(86400 * (todayDay! - 1)) + 32400)//이번달의 첫번째 날
        
        let secondDay = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: firstDay)
        let thirdDay = Date(timeIntervalSince1970: secondDay!.timeIntervalSince1970 + Double(32400))
        firstDay = thirdDay
        
        var temp3 = [PromiseAndProgress1]()
        
        self.getAllDataWithDate(day: firstDay) { (result) in
            temp3.append(result)
        self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(1 * 86400) ) ) { (result2) in
                temp3.append(result2)
        self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(2 * 86400) ) ) { (result2) in
                    temp3.append(result2)
        self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(3 * 86400)) ) { (result2) in
                        temp3.append(result2)
        self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(4 * 86400) ) ) { (result2) in
                            temp3.append(result2)
        self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(5 * 86400)) ) { (result2) in
                                temp3.append(result2)
        self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(6 * 86400) ) ) { (result2) in
                                    temp3.append(result2)
        self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(7 * 86400)) ) { (result2) in
                                        temp3.append(result2)
        self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(8 * 86400) ) ) { (result2) in
                                            temp3.append(result2)
        self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(9 * 86400) ) ) { (result2) in
                                                temp3.append(result2)
        self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(10 * 86400) ) ) { (result2) in
                                                    temp3.append(result2)
        self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(11 * 86400)) ) { (result2) in
                                                        temp3.append(result2)
        self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(12 * 86400) ) ) { (result2) in
                                                            temp3.append(result2)
        self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(13 * 86400) ) ) { (result2) in
                                                                temp3.append(result2)
        self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(14 * 86400)) ) { (result2) in
                                                                    temp3.append(result2)
        self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(15 * 86400)) ) { (result2) in
                                                                        temp3.append(result2)
         self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(16 * 86400) ) ) { (result2) in
                                                                            temp3.append(result2)
        self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(17 * 86400)) ) { (result2) in
             temp3.append(result2)
        self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(18 * 86400)) ) { (result2) in
                         temp3.append(result2)
        self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(19 * 86400) ) ) { (result2) in
         temp3.append(result2)
        self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(20 * 86400)) ) { (result2) in
              temp3.append(result2)
        self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(21 * 86400) ) ) { (result2) in
            temp3.append(result2)
        self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(22 * 86400) ) ) { (result2) in
             temp3.append(result2)
        self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(23 * 86400)) ) { (result2) in
            temp3.append(result2)
        self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(24 * 86400) ) ) { (result2) in
            temp3.append(result2)
        self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(25 * 86400) ) ) { (result2) in
             temp3.append(result2)
        self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(26 * 86400) ) ) { (result2) in
            temp3.append(result2)
        self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(27 * 86400) ) ) { (result2) in
            temp3.append(result2)
        self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(28 * 86400) ) ) { (result2) in
        temp3.append(result2)
            if days > 29 {
       self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(29 * 86400) ) ) { (result2) in
                temp3.append(result2)
        if days > 30 {
            self.getAllDataWithDate(day: Date(timeIntervalSince1970: firstDay.timeIntervalSince1970 + Double(30 * 86400) ) ) { (result2) in
                temp3.append(result2)
                completion(temp3)
            }
        } else {
            completion(temp3)
        }}} else {
                completion(temp3)
            }}}}}}}}}}}}}}}}}}}}}} }}}}}}}}
    }
        
    func getAllDataWithDate(day: Date, completion: @escaping (PromiseAndProgress1) -> Void) {
        
        promiseCollectionRef.whereField(PROMISEUSERS, arrayContains: FirebaseUserService.currentUserID).getDocuments { (snapShot, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                let promises = PromiseTable.parseData(snapShot: snapShot)
                let dayT = floor(day.timeIntervalSince1970/86400)*86400+54000
                let promises2 = promises.filter { $0.promiseEndTime.timeIntervalSince1970 >= dayT && $0.promiseStartTime.timeIntervalSince1970 <= dayT }
                
                var temp = [PromiseAndProgressNotDay]()
                
                for douc in promises2 {
                    
                    self.progressCollectionRef.whereField(USERID, isEqualTo: FirebaseUserService.currentUserID).whereField(PROMISEID, isEqualTo: douc.promiseId).getDocuments { (snapShot, error) in
                        if let err = error {
                            print(err.localizedDescription)
                        } else {
                            let progress1 = ProgressTable.parseData(snapShot: snapShot)
                            if progress1.count > 0 {
                                let temp2 = PromiseAndProgressNotDay(promiseData: douc, progressData: progress1[0])
                                temp.append(temp2)
                            
                                if temp.count == promises2.count {
                                    completion(PromiseAndProgress1(Day: day, PAPD: temp))
                                }
                            }
                        }
                    }
                    
                }
                if promises2.count == 0 {
                    completion(PromiseAndProgress1(Day: day, PAPD: temp))
                }
            }
        }
    }
    
    //오늘을 기준으로 이번 달의 날짜를 반환
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
        
}
