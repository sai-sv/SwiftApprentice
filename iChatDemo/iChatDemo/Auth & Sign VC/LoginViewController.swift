//
//  LoginViewController.swift
//  iChatDemo
//
//  Created by Admin on 10.03.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
    private let greetingLabel = UILabel(text: "Welcome Back!", font: .avenirFont(size: 26))
    
    private let googleLabel = UILabel(text: "Login with")
    private let googleButton = UIButton(title: "Google", titleColor: .blackColor, backgroundColor: .whiteColor, isShadow: true)
    
    private let orLabel = UILabel(text: "or")
    
    private let emailLabel = UILabel(text: "Email")
    private let emailTextField = OneLineTextField(font: .avenirFont())
    
    private let passwordLabel = UILabel(text: "Password")
    private let passwordTextField = OneLineTextField(font: .avenirFont())
    
    private let loginButton = UIButton(title: "Login", titleColor: .whiteColor, backgroundColor: .blackColor, isShadow: true)
    
    private let needAnAccountLabel = UILabel(text: "Need an account?")
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(.redColor, for: .normal)
        button.titleLabel?.font = .avenirFont()
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    weak var delegate: AuthVCRoutingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        googleButton.customizeGoogleButton()
        
        setupConstraints()
        
        googleButton.addTarget(self, action: #selector(googleLoginButtonAction), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        
        let googleButtonView = ButtonWithLabelView(label: googleLabel, button: googleButton)
        let emailStackView = UIStackView(subviews: [emailLabel, emailTextField], spacing: 0)
        let passwordStackView = UIStackView(subviews: [passwordLabel, passwordTextField], spacing: 0)
        let stackView = UIStackView(subviews: [googleButtonView, orLabel, emailStackView, passwordStackView, loginButton])
        
        let footerStackView = UIStackView(subviews: [needAnAccountLabel, signUpButton], axis: .horizontal, spacing: 10)
        footerStackView.alignment = .firstBaseline
        
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        footerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(greetingLabel)
        view.addSubview(stackView)
        view.addSubview(footerStackView)
        
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.topPadding),
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            loginButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            
            footerStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            footerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            footerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding)
        ])
    }
    
    @objc private func googleLoginButtonAction() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc private func loginButtonAction() {        
        AuthService.shared.login(email: emailTextField.text, password: passwordTextField.text) { (result) in
            switch result {
            case .success(let user):
                self.showAlert(title: "Успешно", message: "Вы авторизованы") {
                    // check if profile exist and all profile field's filled
                    FirestoreService.shared.getUserProfile(user: user) { (result) in
                        switch result {
                        case .failure(let error):
                            print(#function + "user profile error: \(error.localizedDescription)")
                            self.present(SetupProfileViewController(user: user), animated: true, completion: nil)
                        case .success(let userModel):
                            let mainTabBarVC = MainTabBarController(currentUser: userModel)
                            mainTabBarVC.modalPresentationStyle = .fullScreen
                            self.present(mainTabBarVC, animated: true, completion: nil)
                        }
                    }
                }
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
    
    @objc private func signUpButtonAction() {
        dismiss(animated: true) {
            self.delegate?.toSignUpVC()
        }
    }
}


// MARK: - SwiftUI
import SwiftUI

struct LoginVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = LoginViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<LoginVCProvider.ContainerView>) -> LoginViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: LoginVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<LoginVCProvider.ContainerView>) {
        }
    }
}
