//
//  UserChatCell.swift
//  iChatDemo
//
//  Created by Admin on 15.03.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import UIKit
import SDWebImage

class UserChatCell: UICollectionViewCell {
    
    private var photoImageView = UIImageView()
    private var usernameLabel = UILabel(text: "Sergei", font: .laoSangmanFont())
    private var mainView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        mainView.backgroundColor = .white
        
        layer.cornerRadius = 4
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 2, height: 4)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.addSubview(photoImageView)
        mainView.addSubview(usernameLabel)
        addSubview(mainView)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: topAnchor),
            mainView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            photoImageView.topAnchor.constraint(equalTo: mainView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            photoImageView.heightAnchor.constraint(equalTo: mainView.widthAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 4),
            usernameLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 15),
            usernameLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -15),
            usernameLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = 4
    }
}

// MARK: - Collection View Cell Protocol
extension UserChatCell: CollectionViewCellProtocol {
    static var id = "UserChatCell"
    func configure<U>(with data: U) where U : Hashable {
        guard let model = data as? UserModel else { return }
        
        usernameLabel.text = model.username
        
        if let url = URL(string: model.avatarStringURL) {
            photoImageView.sd_setImage(with: url)
        }
    }
}

// MARK: - SwiftUI
import SwiftUI

struct UserChatCellProvider: PreviewProvider {
    typealias ProviderType = UserChatCellProvider
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
