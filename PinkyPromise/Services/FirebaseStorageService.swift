//
//  FirebaseStorageService.swift
//  PinkyPromise
//
//  Created by apple on 2020/01/22.
//  Copyright © 2020 hyejikim. All rights reserved.
//
import UIKit
import Foundation
import FirebaseStorage

class FirebaseStorageService: NSObject {
    static let shared = FirebaseStorageService()
    
    private let promiseFolderRef: StorageReference = Storage.storage().reference().child("promiseImage")
    private let userFolderRef: StorageReference = Storage.storage().reference().child("userImage")
    
    //약속이미지를 업로드할 때 사용하는 함수
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
    
    //유저이미지를 업로드할때 사용하는 함수
    func storeUserImage(image: Data, imageName: String, completion: @escaping (Result<String, Error>) -> () ) {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        //let uuid = UUID()
        //let imageLocation = userFolderRef.child(uuid.description)
        let imageLocation = userFolderRef.child(imageName)
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
    
    //약속 이미지를 받아올 때 사용하는 함수
    func getPromiseImageWithName(name: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        promiseFolderRef.storage.reference(withPath: "promiseImage/\(name)").getData(maxSize: 20000000) { (data, error) in
            if let err = error {
                completion(.failure(err))
            } else if let data = data, let image = UIImage(data: data){
                completion(.success(image))
            }
        }
    }
    
    //유저 이미지를 받아올 때 사용하는 함수
    func getUserImageWithName(name: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        
        userFolderRef.storage.reference(withPath: "userImage/\(name)").getData(maxSize: 20000000) { (data, error) in
            if let err = error {
                completion(.failure(err))
            } else if let data = data, let image = UIImage(data: data){
                completion(.success(image))
            }
        }
    }
    
    //사용예시
    //    private func getSetImage() {
    //        if let photoUrl = post?.photoUrl {
    //            FirebaseStorageService.uploadManager.getImage(url: photoUrl) { (result) in
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
