//
//  ChatModel.swift
//  iChatDemo
//
//  Created by Admin on 15.03.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import UIKit
import FirebaseFirestore

struct ChatModel: Hashable, Decodable {
    var friendUsername: String
    var friendAvatarStringURL: String
    var lastMessage: String
    var friendId: String
    
    func representation() -> [String: Any] {
        let rep = ["friendName": friendUsername,
                   "friendAvatarURL": friendAvatarStringURL,
                   "lastMessage": lastMessage,
                   "friendId": friendId]
        return rep
    }
    
    init(friendUsername: String, friendAvatarStringURL: String, lastMessage: String, friendId: String) {
        self.friendUsername = friendUsername
        self.friendAvatarStringURL = friendAvatarStringURL
        self.lastMessage = lastMessage
        self.friendId = friendId
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let username = data["friendName"] as? String,
            let avatarURL = data["friendAvatarURL"] as? String,
            let lastMessage = data["lastMessage"] as? String,
            let id = data["friendId"] as? String else {
                return nil
        }
        self.friendUsername = username
        self.friendAvatarStringURL = avatarURL
        self.lastMessage = lastMessage
        self.friendId = id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendId)
    }
    
    static func == (lhs: ChatModel, rhs: ChatModel) -> Bool {
        return lhs.friendId == rhs.friendId
    }
}
