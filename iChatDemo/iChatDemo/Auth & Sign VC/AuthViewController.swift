//
//  ViewController.swift
//  iChatDemo
//
//  Created by Admin on 08.03.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import UIKit
import GoogleSignIn

class AuthViewController: UIViewController {

    private let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Logo"), contentMode: .scaleAspectFit)
    
    private let googleLabel = UILabel(text: "Get started with")
    private let emailLabel = UILabel(text: "Or sigh up with")
    private let loginLabel = UILabel(text: "Already onboard?")
    
    private let googleButton = UIButton(title: "Google", titleColor: .blackColor, backgroundColor: .whiteColor, isShadow: true)
    private let emailButton = UIButton(title: "Email", titleColor: .whiteColor, backgroundColor: .blackColor)
    private let loginButton = UIButton(title: "Login", titleColor: .redColor, backgroundColor: .whiteColor, isShadow: true)
    
    private let loginVC = LoginViewController()
    private let signUpVC = SignUpViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        googleButton.customizeGoogleButton()
        
        setupConstraints()
        
        emailButton.addTarget(self, action: #selector(emailButtonAction), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleLoginButtonAction), for: .touchUpInside)
        
        loginVC.delegate = self
        signUpVC.delegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    private func setupConstraints() {

        let googleButtonView = ButtonWithLabelView(label: googleLabel, button: googleButton)
        let emailButtonView = ButtonWithLabelView(label: emailLabel, button: emailButton)
        let loginButtonView = ButtonWithLabelView(label: loginLabel, button: loginButton)
        let stackView = UIStackView(subviews: [googleButtonView, emailButtonView, loginButtonView])
        
        view.addSubview(logoImageView)
        view.addSubview(stackView)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.topPadding),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 160),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
        ])
    }
    
    @objc func emailButtonAction() {
        present(signUpVC, animated: true, completion: nil)
    }
    
    @objc func loginButtonAction() {
        present(loginVC, animated: true, completion: nil)
    }
    
    @objc func googleLoginButtonAction() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
}

extension AuthViewController: AuthVCRoutingDelegate {
    func toSignUpVC() {
        self.present(signUpVC, animated: true, completion: nil)
    }
    
    func toLoginVC() {
        self.present(loginVC, animated: true, completion: nil)
    }
}

// MARK: - GIDSignInDelegate
extension AuthViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        AuthService.shared.googleLogin(user: user, withError: error) { (result) in
            switch result {
            case .failure(let error):
                self.showAlert(title: "Ошибка!", message: error.localizedDescription)
            case .success(let user):
                FirestoreService.shared.getUserProfile(user: user) { (result) in
                    
                    let topVC = UIApplication.getTopViewController()
                    switch result {
                    case .failure(let error):
                        print(#function + "user profile error: \(error.localizedDescription)")
                        topVC?.showAlert(title: "Успешно!", message: "Вы зарегистрированы!") {
                            topVC?.present(SetupProfileViewController(user: user), animated: true)
                        }
                    case .success(let userModel):
                        topVC?.showAlert(title: "Успешно!", message: "Вы авторизованы!") {
                            let mainTabBarVC = MainTabBarController(currentUser: userModel)
                            mainTabBarVC.modalPresentationStyle = .fullScreen
                            topVC?.present(mainTabBarVC, animated: true)
                        }
                    } // result
                }
            }
        }
    } // end sign func
}

// MARK: - SwiftUI
import SwiftUI

struct AuthVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {

        let viewController = AuthViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<AuthVCProvider.ContainerView>) -> AuthViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: AuthVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<AuthVCProvider.ContainerView>) {
        }
    }
}
