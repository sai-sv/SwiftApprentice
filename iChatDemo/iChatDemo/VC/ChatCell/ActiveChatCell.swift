//
//  ActiveChatCell.swift
//  iChatDemo
//
//  Created by Admin on 12.03.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import UIKit

class ActiveChatCell: UICollectionViewCell {
    
    private let photoView = UIImageView()
    private let nameLabel = UILabel(text: "Name", font: .laoSangmanFont(size: 20))
    private let lastMessageLabel = UILabel(text: "Last message", font: .laoSangmanFont(size: 18))
    private let gradientView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        layer.cornerRadius = 4
        clipsToBounds = true
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        gradientView.backgroundColor = .black
        
        photoView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        lastMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(photoView)
        addSubview(nameLabel)
        addSubview(lastMessageLabel)
        addSubview(gradientView)
        
        NSLayoutConstraint.activate([
            photoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoView.centerYAnchor.constraint(equalTo: centerYAnchor),
            photoView.heightAnchor.constraint(equalToConstant: 78),
            photoView.widthAnchor.constraint(equalToConstant: 78),
            
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: -16),
            
            lastMessageLabel.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: 16),
            lastMessageLabel.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: -16),
            lastMessageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.centerYAnchor.constraint(equalTo: centerYAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 78),
            gradientView.widthAnchor.constraint(equalToConstant: 8)
        ])
    }
}

// MARK: - Collection View Cell Protocol
extension ActiveChatCell: CollectionViewCellProtocol {
    static var id: String = "ActiveChatCell"
    
    func configure<U: Hashable>(with data: U) {
        guard let model = data as? ChatModel else { return }
        
        photoView.image = UIImage(named: model.friendAvatarStringURL)
        nameLabel.text = model.friendUsername
        lastMessageLabel.text = model.lastMessage
        photoView.sd_setImage(with: URL(string: model.friendAvatarStringURL), completed: nil)
    }
}

// MARK: - SwiftUI
import SwiftUI

struct ActiveChatCellProvider: PreviewProvider {
    typealias ProviderType = ActiveChatCellProvider
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
