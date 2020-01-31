//
//  API-Auth.swift
//  APIWithFirebase
//
//  Created by DevKang on 2020/01/31.
//  Copyright © 2020 DevKang. All rights reserved.
//

import Foundation
import AuthenticationServices
import CryptoKit
import FirebaseFirestore

class API {
    static let shared = API()
}

//extension API {
//    private var userDocumentRef: CollectionReference {
//        return Firestore.firestore().collection("users")
//    }
//    
//    func addUser(user:User, completion: (() -> Void)?) {
//        if let data = try? user.asDictionary() {
//            self.userDocumentRef.addDocument(data: data, completion: { _ in
//                completion?()
//            })
//        }
//    }
//}

extension API {
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
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

        return result
    }

    @available(iOS 13, *)
    func startSignInWithAppleFlow<T: UIViewController & ASAuthorizationControllerDelegate & ASAuthorizationControllerPresentationContextProviding>(vc: T) -> String {
        let nonce = randomNonceString()
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = vc
        authorizationController.presentationContextProvider = vc
        authorizationController.performRequests()
        return nonce
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}
