//
//  AuthService.swift
//  VKDemo
//
//  Created by Admin on 22.12.2019.
//  Copyright © 2019 sergei. All rights reserved.
//

import Foundation
import VKSdkFramework

class AuthService: NSObject, VKSdkDelegate, VKSdkUIDelegate {
    
    private let appId: String = "7255052"
    private var vkSdk: VKSdk
    
    var accessToken: String? {
        return VKSdk.accessToken()?.accessToken
    }
    var userId: String? {
        return VKSdk.accessToken()?.userId
    }
    
    override init() {
        self.vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        print("auth service initialized")
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }
    
    func wakeUpSession() {
        
        let permissions = ["wall", "friends"]
        VKSdk.wakeUpSession(permissions) { [weak self] (authState, error) in
            
            switch authState {
            case .authorized:
                self?.showNewsFeedVC()
                break
            case .initialized:
                VKSdk.authorize(permissions)
                break
            default:
                print(String(describing: authState))
            }
        }
    }
    
    private func showNewsFeedVC() {
        guard let window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window else {
            return
        }
        
        let storyboard = UIStoryboard.init(name: "NewsFeed", bundle: nil)
        if let newsFeedVC = storyboard.instantiateInitialViewController() as? NewsFeedViewController {
            let navigationVC = UINavigationController(rootViewController: newsFeedVC)
            navigationVC.modalPresentationStyle = .fullScreen
            window.rootViewController = navigationVC
        }
    }    
    
    // MARK: VKSdkDelegate
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print(#function)
        if result.token != nil {
            showNewsFeedVC()
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print(#function)
    }
    
    // MARK: - VKSdkUIDelegate
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print(#function)
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController?.present(controller, animated: true)
        }
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }
}
