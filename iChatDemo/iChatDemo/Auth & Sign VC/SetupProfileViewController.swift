//
//  SetupProfileViewController.swift
//  iChatDemo
//
//  Created by Admin on 10.03.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import UIKit
import FirebaseAuth

class SetupProfileViewController: UIViewController {
    
    private let titleLabel = UILabel(text: "Set up profile", font: .avenirFont(size: 26))
    private let userProfilePhotoView = UserProfilePhotoView()
    
    private let fullNameLabel = UILabel(text: "Full name")
    private let fullNameTextField = OneLineTextField(font: .avenirFont())
    
    private let aboutLabel = UILabel(text: "About me")
    private let aboutTextField = OneLineTextField(font: .avenirFont())
    
    private let genderLabel = UILabel(text: "Gender")
    private let genderControl: UISegmentedControl = { 
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "Male", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Female", at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private let goToChatsButton: UIButton = {
        let button = UIButton(title: "Go to chats!", titleColor: .whiteColor, backgroundColor: .blackColor)
        return button
    }()
    
    private let currentUser: User // FirebaseAuth User
    
    init(user: User) {
        currentUser = user
        
        super.init(nibName: nil, bundle: nil)
        
        if let name = currentUser.displayName {
            fullNameTextField.text = name // set google profile name if exist
        }
        if let url = currentUser.photoURL {
            userProfilePhotoView.userPhoto.sd_setImage(with: url) // set google profile photo if exist
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupConstraints()
        
        userProfilePhotoView.addPhotoButton.addTarget(self, action: #selector(selectUserPhotoAction), for: .touchUpInside)
        goToChatsButton.addTarget(self, action: #selector(goToChatsButtonAction), for: .touchUpInside)
    }
    
    @objc private func selectUserPhotoAction() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    @objc private func goToChatsButtonAction() {
        
        guard let email = currentUser.email else {
            return
        }
        FirestoreService.shared.saveProfile(id: currentUser.uid,
                                            email: email,
                                            username: fullNameTextField.text,
                                            gender: genderControl.titleForSegment(at: genderControl.selectedSegmentIndex),
                                            description: aboutTextField.text,
                                            avatarImage: userProfilePhotoView.userPhoto.image) { (result) in
                                                switch result {
                                                case .failure(let error):
                                                    self.showAlert(title: "Ошибка!", message: error.localizedDescription)
                                                case .success(let userModel):
                                                    self.showAlert(title: "Успешно!", message: "Приятного общения") {
                                                        let mainTabBarVC = MainTabBarController(currentUser: userModel)
                                                        mainTabBarVC.modalPresentationStyle = .fullScreen
                                                        self.present(mainTabBarVC, animated: true)
                                                    }
                                                    
                                                }
        }
    }
    
    private func setupConstraints() {
        
        let fullNameStackView = UIStackView(subviews: [fullNameLabel, fullNameTextField], spacing: 0)
        let aboutStackView = UIStackView(subviews: [aboutLabel, aboutTextField], spacing: 0)
        let genderStackView = UIStackView(subviews: [genderLabel, genderControl], spacing: 12)
        let stackView = UIStackView(subviews: [fullNameStackView, aboutStackView, genderStackView, goToChatsButton])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        userProfilePhotoView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(userProfilePhotoView)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.topPadding),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            userProfilePhotoView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            userProfilePhotoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: userProfilePhotoView.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            goToChatsButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }
}

// MARK: - UIImagePickerControllerDelegate
extension SetupProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        userProfilePhotoView.userPhoto.image = image
    }
}

// MARK: - SwiftUI
import SwiftUI

struct SetupProfileVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = SetupProfileViewController(user: Auth.auth().currentUser!)
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<SetupProfileVCProvider.ContainerView>) -> SetupProfileViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: SetupProfileVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SetupProfileVCProvider.ContainerView>) {
        }
    }
}
