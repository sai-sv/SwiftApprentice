//
//  WaitingChatNavigation.swift
//  iChatDemo
//
//  Created by Admin on 11.04.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import Foundation

protocol WaitingChatNavigation: class {
    
    func acceptRequest(chatModel: ChatModel)
    func denyRequest(chatModel: ChatModel)
}
