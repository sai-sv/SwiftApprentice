//
//  MainTabBarController.swift
//  iChatDemo
//
//  Created by Admin on 11.03.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private var currentUser: UserModel
    
    init(currentUser: UserModel = UserModel(id: "", email: "", username: "", gender: "", description: "", avatarStringURL: "")) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let imgConfiguration = UIImage.SymbolConfiguration(weight: .medium)
        
        tabBar.tintColor = #colorLiteral(red: 0.5568627451, green: 0.3529411765, blue: 0.968627451, alpha: 1)
        viewControllers = [
            generateNavigationController(viewController: PeopleViewController(currentUser: currentUser),
            title: "People",
            image: UIImage(systemName: "person.2", withConfiguration: imgConfiguration)),
            generateNavigationController(viewController: ListViewController(currentUser: currentUser),
            title: "Conversation",
            image: UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: imgConfiguration))
        ]
    }
    
    private func generateNavigationController(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        let nvc = UINavigationController(rootViewController: viewController)
        nvc.tabBarItem.title = title
        nvc.tabBarItem.image = image
        return nvc
    }
}

// MARK: - SwiftUI
import SwiftUI

struct MainTabBarVCProvider: PreviewProvider {
    typealias ProviderType = MainTabBarVCProvider
    typealias VCType = MainTabBarController
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = VCType()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ProviderType.ContainerView>) -> VCType {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: ProviderType.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ProviderType.ContainerView>) {
        }
    }
}
