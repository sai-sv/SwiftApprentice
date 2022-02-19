//
//  ChatRequestViewController.swift
//  iChatDemo
//
//  Created by Admin on 16.03.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import UIKit

class ChatRequestViewController: UIViewController {
    
    private var imageView = UIImageView(image: #imageLiteral(resourceName: "human10"), contentMode: .scaleAspectFill)
    private var usernameLabel = UILabel(text: "Ariana Grande", font: .systemFont(ofSize: 20, weight: .medium))
    private var aboutMeLabel = UILabel(text: "Some text here...", font: .systemFont(ofSize: 16, weight: .light))
    private var acceptButton = UIButton(title: "ACCEPT", titleColor: .whiteColor, backgroundColor: .blackColor, isShadow: false, cornerRadius: 10)
    private var denyButton = UIButton(title: "DENY", titleColor: #colorLiteral(red: 0.8352941176, green: 0.2, blue: 0.2, alpha: 1), backgroundColor: .whiteColor, isShadow: false, cornerRadius: 10)
    private var containerView = UIView()
    
    private let chatModel: ChatModel
    weak var delegate: WaitingChatNavigation?
    
    init(chatModel: ChatModel) {
        self.chatModel = chatModel
        self.imageView.sd_setImage(with: URL(string: chatModel.friendAvatarStringURL), completed: nil)
        self.usernameLabel.text = chatModel.friendUsername
        
        super.init(nibName: nil, bundle: nil)
        
        acceptButton.addTarget(self, action: #selector(acceptButtonAction), for: .touchUpInside)
        denyButton.addTarget(self, action: #selector(denyButtonAction), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func acceptButtonAction() {
        self.dismiss(animated: true) {
            self.delegate?.acceptRequest(chatModel: self.chatModel)
        }
    }
    
    @objc private func denyButtonAction() {
        self.dismiss(animated: true) {
            self.delegate?.denyRequest(chatModel: self.chatModel)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aboutMeLabel.numberOfLines = 0
        
        containerView.backgroundColor = .whiteColor
        containerView.layer.cornerRadius = 30
        
        denyButton.layer.borderWidth = 1.2
        denyButton.layer.borderColor = #colorLiteral(red: 0.8352941176, green: 0.2, blue: 0.2, alpha: 1)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonStackView = UIStackView(subviews: [acceptButton, denyButton], axis: .horizontal, spacing: 8)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.distribution = .fillEqually
        
        view.addSubview(imageView)
        view.addSubview(containerView)
        
        containerView.addSubview(usernameLabel)
        containerView.addSubview(aboutMeLabel)
        containerView.addSubview(buttonStackView)
        
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
            
            buttonStackView.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 24),
            buttonStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            buttonStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            buttonStackView.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        acceptButton.applyGradients(cornerRadius: 10)
    }
}


// MARK: - SwiftUI
/*import SwiftUI

struct ChatRequestVCProvider: PreviewProvider {
    typealias ProviderType = ChatRequestVCProvider
    typealias VCType = ChatRequestViewController
    
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
