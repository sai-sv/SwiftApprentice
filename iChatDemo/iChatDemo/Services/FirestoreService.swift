//
//  FirestoreService.swift
//  iChatDemo
//
//  Created by Admin on 26.03.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirestoreService {
    
    static let shared = FirestoreService()
    
    private let db = Firestore.firestore()
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    private var currentUser: UserModel!
    
    func saveProfile(id: String, email: String, username: String?, gender: String?, description: String?, avatarImage: UIImage?,
                     completion: @escaping (Result<UserModel, Error>) -> Void) {
        
        guard Validators.isFilled(username: username, gender: gender, description: description) else {
            completion(.failure(UserError.notFilled))
            return
        }
        
        guard let photo = avatarImage, photo != #imageLiteral(resourceName: "avatar") else {
            completion(.failure(UserError.photoNotExist))
            return
        }
        
        var userModel = UserModel(id: id,
                                  email: email,
                                  username: username!,
                                  gender: gender!,
                                  description: description!,
                                  avatarStringURL: "no photo")
        
        StorageService.shared.upload(image: photo) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let photoURL):
                userModel.avatarStringURL = photoURL.absoluteString
                
                self.usersRef.document(userModel.id).setData(userModel.representation()) { (error) in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(userModel))
                    }
                }
            }
        } // StorageService upload
    }
    
    func getUserProfile(user: User, completion: @escaping (Result<UserModel, Error>) -> Void) {
        
        let userDocRref = usersRef.document(user.uid)
        userDocRref.getDocument { (docSnapshot, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let snapshot = docSnapshot, snapshot.exists else {
                completion(.failure(UserError.profileNotExist))
                return
            }
            
            guard let userModel = UserModel(document: snapshot) else {
                completion(.failure(UserError.documentConversionFailed))
                return
            }
            self.currentUser = userModel
            completion(.success(userModel))
        }
    }
    
    func chatRequest(message: String, receiverUser: UserModel, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let waitingChatsRef = db.collection(["users", receiverUser.id, "waitingChats"].joined(separator: "/"))
        let messagesRef = waitingChatsRef.document(currentUser.id).collection("messages")
        
        let messageModel = MessageModel(user: currentUser, content: message)
        
        let chatModel = ChatModel(friendUsername: currentUser.username,
                                  friendAvatarStringURL: currentUser.avatarStringURL,
                                  lastMessage: messageModel.content,
                                  friendId: currentUser.id)
        waitingChatsRef.document(currentUser.id).setData(chatModel.representation()) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            messagesRef.addDocument(data: messageModel.representation()) { (error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(Void()))
            }
        }
    }
    
    func deleteChat(chatModel: ChatModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let waitingChatsRef = db.collection(["users", currentUser.id, "waitingChats"].joined(separator: "/"))
        let messagesRef = waitingChatsRef.document(chatModel.friendId).collection("messages")
        
        // first of all delete all messages
        messagesRef.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                completion(.failure(error!))
                return
            }
            for message in snapshot.documents {
                messagesRef.document(message.documentID).delete { (error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                }
            } // for_each msg
        }
        
        // delete waitingChat
        waitingChatsRef.document(chatModel.friendId).delete { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
        }
        completion(.success(Void()))
    }
    
    func changeToActive(chatModel: ChatModel, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let activeChatsRef = db.collection(["users", currentUser.id, "activeChats"].joined(separator: "/"))
        let messagesRef = activeChatsRef.document(chatModel.friendId).collection("messages")
        
        getWaitingChatMessages(friendId: chatModel.friendId) { (result) in
            
            switch result {
            case .success(let messages):
                self.deleteChat(chatModel: chatModel) { (result) in
                    switch result {
                    case .success:
                        
                        activeChatsRef.document(chatModel.friendId).setData(chatModel.representation()) { (error) in
                            if let error = error {
                                completion(.failure(error))
                                return
                            }
                            
                            // add all messages to collection
                            for messageModel in messages {
                                messagesRef.addDocument(data: messageModel.representation()) { (error) in
                                    if let error = error {
                                        completion(.failure(error))
                                        return
                                    }
                                }
                            }
                        } // add active chat to collection
                        
                        completion(.success(Void()))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
            } // deleteChat
            case .failure(let error):
                completion(.failure(error))
            } // getWaitingChatMessages
        }
    }
    
    private func getWaitingChatMessages(friendId: String, completion: @escaping (Result<[MessageModel], Error>) -> Void) {
        let waitingChatsRef = db.collection(["users", currentUser.id, "waitingChats"].joined(separator: "/"))
        let messagesRef = waitingChatsRef.document(friendId).collection("messages")
        
        messagesRef.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                completion(.failure(error!))
                return
            }
            var messages: [MessageModel] = []
            for message in snapshot.documents {
                guard let message = MessageModel(document: message) else {
                    return
                }
                messages.append(message)
            }
            completion(.success(messages))
        }
    }
    
    func sendMessage(chatModel: ChatModel, message: MessageModel, completion: @escaping (Result<Void, Error>) -> Void) {
        
        
        let receiverActiveChatsRef = usersRef.document(chatModel.friendId).collection("activeChats").document(currentUser.id)
        let recieverMessagesRef = receiverActiveChatsRef.collection("messages")
        
        let myMessagesRef = usersRef
            .document(currentUser.id).collection("activeChats")
            .document(chatModel.friendId).collection("messages")
        
        let chatModel = ChatModel(friendUsername: currentUser.username,
                                  friendAvatarStringURL: currentUser.avatarStringURL,
                                  lastMessage: message.content,
                                  friendId: currentUser.id)
        
        // add active chat data
        receiverActiveChatsRef.setData(chatModel.representation()) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            // add message to reciver
            recieverMessagesRef.addDocument(data: message.representation()) { (error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                // add myself message
                myMessagesRef.addDocument(data: message.representation()) { (error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                }
            } // add message to receiver
        } // add active chat data
    }
}
