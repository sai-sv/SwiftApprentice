//
//  StorageListner.swift
//  iChatDemo
//
//  Created by Admin on 28.03.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class StorageListner {
    
    enum ChatType {
        case WaitingChat
        case ActiveChat
    }
    
    static let shared = StorageListner()
    
    private let db = Firestore.firestore()
    private var usersRef: CollectionReference  {
        return db.collection("users")
    }
    private var currentUserId: String {
        return Auth.auth().currentUser!.uid
    }
    
    func observe(users: [UserModel], completion: @escaping (Result<[UserModel], Error>) -> Void) -> ListenerRegistration {
        
        var users = users
        let listner = usersRef.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            snapshot.documentChanges.forEach { (documentChange) in
                guard let userModel = UserModel(document: documentChange.document) else {
                    return
                }
                switch documentChange.type {
                case .added:
                    guard !users.contains(userModel) else { return }
                    guard let currentUserId = Auth.auth().currentUser?.uid,
                        currentUserId != userModel.id else {
                        return
                    }
                    users.append(userModel)
                case .modified:
                    if let index = users.firstIndex(of: userModel) {
                        users[index] = userModel
                    }
                case .removed:
                    if let index = users.firstIndex(of: userModel) {
                        users.remove(at: index)
                    }
                }
            }
            completion(.success(users))
        } // addSnapshotListner
        
        return listner
    }
    
    func observeChats(chatType: ChatType, chats: [ChatModel], completion: @escaping (Result<[ChatModel], Error>) -> Void) -> ListenerRegistration {
        
        var chats = chats        
        let chatName = chatType == .WaitingChat ? "waitingChats" : "activeChats"
        let chatsRef = db.collection(["users", currentUserId, chatName].joined(separator: "/"))
        
        let listner = chatsRef.addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else {
                completion(.failure(error!))
                return
            }
            
            snapshot.documentChanges.forEach({ (documentChange) in
                
                guard let chatModel = ChatModel(document: documentChange.document) else {
                    return
                }
                
                switch documentChange.type {
                    
                case .added:
                    if !chats.contains(chatModel) {
                        chats.append(chatModel)
                    }
                case .modified:
                    if let index = chats.firstIndex(of: chatModel) {
                        chats[index] = chatModel
                    }
                case .removed:
                    if let index = chats.firstIndex(of: chatModel) {
                        chats.remove(at: index)
                    }
                }
            })
            completion(.success(chats))
        } // addSnapshotListner
        return listner
    }
    
    func messageObserve(chatModel: ChatModel, completion: @escaping (Result<MessageModel, Error>) -> Void) -> ListenerRegistration {
        let ref = usersRef.document(currentUserId).collection("activeChats").document(chatModel.friendId).collection("messages")
        
        let listner = ref.addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else {
                completion(.failure(error!))
                return
            }
            
            snapshot.documentChanges.forEach { (documentChange) in
                guard let messageModel = MessageModel(document: documentChange.document) else {
                    return
                }
                switch documentChange.type {
                case .added:
                    completion(.success(messageModel))
                case .modified:
                    break
                case .removed:
                    break
                }
            } // for each document change
        }
        return listner
    }
}
 
