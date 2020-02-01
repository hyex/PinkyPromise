//
//  FirebaseStorageService.swift
//  PinkyPromise
//
//  Created by apple on 2020/01/22.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit
import Foundation
import FirebaseFirestore
import FirebaseStorage

class FirebaseStorageService: NSObject {
    static let shared = FirebaseStorageService()
    
    private let promiseFolderRef: StorageReference = Storage.storage().reference().child("promiseImage")
    private let userFolderRef: StorageReference = Storage.storage().reference().child("userImage")
    
    //약속이미지를 업로드할 때 사용하는 함수 image는 UIImage가 아니라 jpegData. 밑에 사용예시 추가함
    func storePromiseImage(image: Data, imageName: String, completion: @escaping (Result<String,Error>) -> ()) {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        //let uuid = UUID()
        let imageLocation = promiseFolderRef.child(imageName)
        imageLocation.putData(image, metadata: metadata) { (responseMetadata, error) in
            if let err = error {
                completion(.failure(err))
            } else {
                imageLocation.downloadURL { (url, error) in
                    guard error == nil else {
                        completion(.failure(error!))
                        return
                    }
                    guard let url = url?.absoluteString else {
                        completion(.failure(error!))
                        return
                    }
                    completion(.success(url))
                }
            }
        }
    }
    
    //유저이미지를 업로드할때 사용하는 함수 image는 UIImage가 아니라 jpegData. 밑에 사용예시 추가함
    func storeUserImage(image: Data, completion: @escaping (Result<String, Error>) -> () ) {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        //let uuid = UUID()
        //let imageLocation = userFolderRef.child(uuid.description)
        let imageLocation = userFolderRef.child(FirebaseUserService.currentUserID!)
        imageLocation.putData(image, metadata: metadata) { (responseMetadata, error) in
            if let err = error {
                completion(.failure(err))
            } else {
                Firestore.firestore().collection(PROMISEUSERREF).document(FirebaseUserService.currentUserID!).setData([USERIMAGE : FirebaseUserService.currentUserID], merge: true)
                imageLocation.downloadURL { (url, error) in
                    guard error == nil else {
                        completion(.failure(error!))
                        return
                    }
                    guard let url = url?.absoluteString else {
                        completion(.failure(error!))
                        return
                    }
                    completion(.success(url))
                }
            }
        }
    }
    
    //약속 이미지를 받아올 때 사용하는 함수 인풋은 파이어베이스 스토리지에 저장되어있는 사진이름
    func getPromiseImageWithName(name: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        promiseFolderRef.storage.reference(withPath: "promiseImage/\(name)").getData(maxSize: 20000000) { (data, error) in
            if let err = error {
                completion(.failure(err))
            } else if let data = data, let image = UIImage(data: data){
                completion(.success(image))
            }
        }
    }
    
    //약속 이미지를 받아올 때 사용하는 함수 인풋은 파이어베이스 스토리지에 저장되어있는 사진이름
    func getPromiseImageURLWithName(name: String, completion: @escaping (Result<String, Error>) -> ()) {
        promiseFolderRef.storage.reference().child("promiseImage/\(name)").downloadURL { (url, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            guard let url = url?.absoluteString else {
                completion(.failure(error!))
                return
            }
            completion(.success(url))
        }
    }
    
//    imageLocation.downloadURL { (url, error) in
//        guard error == nil else {
//            completion(.failure(error!))
//            return
//        }
//        guard let url = url?.absoluteString else {
//            completion(.failure(error!))
//            return
//        }
//        completion(.success(url))
//    }
    
    
    //유저 이미지를 받아올 때 사용하는 함수 인풋은 파이어베이스 스토리지에 저장되어있는 사진이름
    func getUserImageWithName(name: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        
        userFolderRef.storage.reference(withPath: "userImage/\(name)").getData(maxSize: 20000000) { (data, error) in
            if let err = error {
                completion(.failure(err))
            } else if let data = data, let image = UIImage(data: data){
                completion(.success(image))
            }
        }
    }
    
    //유저 이미지를 받아올 때 사용하는 함수 인풋은 파이어베이스 스토리지에 저장되어있는 사진이름
    func getUserImageURLWithName(name: String, completion: @escaping (Result<String, Error>) -> ()) {
        promiseFolderRef.storage.reference().child("userImage/\(name)").downloadURL { (url, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            guard let url = url?.absoluteString else {
                completion(.failure(error!))
                return
            }
            completion(.success(url))
        }
    }
    
    //사용예시
    //    private func getSetImage() {
    //        if let photoUrl = post?.photoUrl {
    //            FirebaseStorageService.getImage(url: photoUrl) { (result) in
    //                switch result {
    //                case .failure(let error):
    //                    print(error)
    //                case .success(let firebaseImage):
    //                    self.detailImageView.image = firebaseImage
    //                }
    //            }
    //        }
    //    }
    
}


//firebase storage storeimage 사용예시
//    guard let imageData = self.image?.jpegData(compressionQuality: 1) else {
//        makeAlert(with: "error", and: "could not compress image")
//        return
//    }
//
//    FirebaseStorageService.shared.storeUserImage(image: imageData) { [weak self] (result) in
//        switch result {
//        case .success(let url):
//            self?.imageURL = url
//            print("check 3")
//            print(self?.imageURL)
//        case .failure(let error):
//            print("this is error")
//            print(error)
//        }
//    }
