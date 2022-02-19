//
//  AuthService.swift
//  iChatDemo
//
//  Created by Admin on 17.03.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import Firebase
import GoogleSignIn

class AuthService {
    
    static let shared = AuthService()
    private var auth = Auth.auth()
    
    typealias Handler = (Result<User, Error>) -> Void
    
    func register(email: String?, password: String?, confirmPassword: String?, completion: @escaping Handler) {
        
        guard Validators.isFilled(email: email, password: password, confirmPassword: confirmPassword) else {
            completion(.failure(AuthError.notFilled))
            return
        }
        
        guard password!.lowercased() == confirmPassword!.lowercased() else {
            completion(.failure(AuthError.passwordsNotMatched))
            return
        }
        
        guard Validators.isSimpleEmail(email!) else {
            completion(.failure(AuthError.invalidEmail))
            return
        }
        
        auth.createUser(withEmail: email!, password: password!) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
    
    func login(email: String?, password: String?, completion: @escaping Handler) {
        
        guard let email = email, let password = password else {
            completion(.failure(AuthError.notFilled))
            return
        }
        
        auth.signIn(withEmail: email, password: password) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
    
    func googleLogin(user: GIDGoogleUser!, withError error: Error!, completion: @escaping Handler) {
        
        guard let authentication = user.authentication else {
            completion(.failure(error))
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        auth.signIn(with: credential) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
}
