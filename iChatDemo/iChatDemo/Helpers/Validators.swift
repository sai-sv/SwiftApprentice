//
//  Validators.swift
//  iChatDemo
//
//  Created by Admin on 17.03.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import Foundation

class Validators {
    
    static func isFilled(email: String?, password: String?, confirmPassword: String?) -> Bool {
        guard let password = password,
            let confirmPassword = confirmPassword,
            let email = email,
            password != "",
            confirmPassword != "",
            email != "" else {
                return false
        }
        return true
    }
    
    static func isFilled(username: String?, gender: String?, description: String?) -> Bool {
        guard let username = username,
            let gender = gender,
            let description = description,
            !username.isEmpty,
            !gender.isEmpty,
            !description.isEmpty else {
                return false
        }
        return true
    }
    
    static func isSimpleEmail(_ email: String) -> Bool {
        let emailRegEx = "^.+@.+\\..{2,}$"
        return check(text: email, regEx: emailRegEx)
    }
    
    private static func check(text: String, regEx: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: text)
    }
}
