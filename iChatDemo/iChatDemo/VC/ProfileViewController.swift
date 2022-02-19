//
//  ProfileViewController.swift
//  iChatDemo
//
//  Created by Admin on 16.03.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
    private var userModel: UserModel!
    
    private var imageView = UIImageView(image: #imageLiteral(resourceName: "human10"), contentMode: .scaleAspectFill)
    private var usernameLabel = UILabel(text: "Ariana Grande", font: .systemFont(ofSize: 20, weight: .medium))
    private var aboutMeLabel = UILabel(text: "American singer, songwriter and actress", font: .systemFont(ofSize: 16, weight: .light))
    private var textField = InsertableTextField()
    private var containerView = UIView()
    
    init(userModel: UserModel) {
        super.init(nibName: nil, bundle: nil)
        
        self.userModel = userModel
        self.usernameLabel.text = userModel.username
        self.aboutMeLabel.text = userModel.description
        self.imageView.sd_setImage(with: URL(string: userModel.avatarStringURL), completed: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aboutMeLabel.numberOfLines = 0
        containerView.layer.cornerRadius = 30
        containerView.backgroundColor = .whiteColor
        
        if let button = textField.rightView as? UIButton {
            button.addTarget(self, action: #selector(sendButttonAction), for: .touchUpInside)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(containerView)
        containerView.addSubview(usernameLabel)
        containerView.addSubview(aboutMeLabel)
        containerView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 206),
            
            usernameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 35),
            usernameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            usernameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            
            aboutMeLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            aboutMeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            aboutMeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            
            textField.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            textField.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
    
    @objc private func sendButttonAction() {
        guard let message = textField.text else { return }
        
        dismiss(animated: true) {
            FirestoreService.shared.chatRequest(message: message, receiverUser: self.userModel) { (result) in
                switch result {
                case .failure(let error):
                    UIApplication.getTopViewController()?.showAlert(title: "Ошибка!", message: error.localizedDescription)
                case .success:
                    UIApplication.getTopViewController()?.showAlert(title: "Успешно!",
                                                                    message: "Ваше сообщение для \(self.userModel.username) отправлено")
                }
            }
        }
    }
}

/*
// MARK: - SwiftUI
import SwiftUI

struct ProfileVCProvider: PreviewProvider {
    typealias ProviderType = ProfileVCProvider
    typealias VCType = ProfileViewController
    
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
}*/
