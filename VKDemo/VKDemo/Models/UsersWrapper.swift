//
//  UsersWrapper.swift
//  VKDemo
//
//  Created by Admin on 27.02.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import Foundation
import UIKit

struct UsersWrapper: Decodable {
    let response: [UserResponse]
}

struct UserResponse: Decodable {
    var photo100: String?
}
