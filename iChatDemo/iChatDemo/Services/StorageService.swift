//
//  StorageService.swift
//  iChatDemo
//
//  Created by Admin on 28.03.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import Foundation
import Firebase

class StorageService {
    
    static let shared = StorageService()
    
    private let storageRef = Storage.storage().reference()
    private var avatarsRef: StorageReference {
        return storageRef.child("avatars")
    }
    
    func upload(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        
        guard let userUID = Auth.auth().currentUser?.uid else {
            completion(.failure(UserError.userNotAuthorized))
            return
        }
        
        guard let photo = image.scaledToSafeUploadSize else {
            completion(.failure(UserError.photoScaleFailed))
            return
        }
        
        guard let photoData = photo.jpegData(compressionQuality: 0.4) else {
            completion(.failure(UserError.photoCompressionFailed))
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        avatarsRef.child(userUID).putData(photoData, metadata: metadata) { (metadata, error) in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            
            self.avatarsRef.child(userUID).downloadURL { (url, error) in
                guard let url = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(url))
            }
        }
    }
}
