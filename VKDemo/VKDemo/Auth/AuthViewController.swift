//
//  AuthViewController.swift
//  VKDemo
//
//  Created by Admin on 22.12.2019.
//  Copyright © 2019 sergei. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    private weak var authService: AuthService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authService = AppDelegate.shared().authService
    }
    
    @IBAction func logInAction() {
        authService?.wakeUpSession()
    }
}
