//
//  MessageModel.swift
//  iChatDemo
//
//  Created by Admin on 05.04.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import UIKit
import FirebaseFirestore
import MessageKit

struct MessageModel: Hashable, MessageType {
    
    //var senderName: String
    //var senderId: String
    var content: String
    var sentDate: Date
    var id: String?
    
    // MARK: - MessageType Prototcol
    var sender: SenderType
    var messageId: String {
        return id ?? UUID().uuidString
    }
    var kind: MessageKind {
        return .text(content)
    }
    
    init(user: UserModel, content: String) {
        //senderName = user.username
        //senderId = user.id
        self.content = content
        sentDate = Date()
        self.id = nil
        self.sender = Sender(senderId: user.id, displayName: user.username)
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let senderName = data["senderName"] as? String,
            let senderId = data["senderId"] as? String,
            let sentDate = data["sentDate"] as? Timestamp,
            let content = data["content"] as? String else {
                return nil
        }
        //self.senderName = senderName
        //self.senderId = senderId
        self.content = content
        self.sentDate = sentDate.dateValue()
        self.id = document.documentID
        self.sender = Sender(senderId: senderId, displayName: senderName)
    }
    
    func representation() -> [String: Any] {
        return ["senderName": sender.displayName,
                "senderId": sender.senderId,
                "sentDate": sentDate,
                "content": content]
    }
    
    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    static func == (lhs: MessageModel, rhs: MessageModel) -> Bool {
        return lhs.messageId == rhs.messageId
    }
}

// MARK: - Comparable
extension MessageModel: Comparable {
    
    static func < (lhs: MessageModel, rhs: MessageModel) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}
