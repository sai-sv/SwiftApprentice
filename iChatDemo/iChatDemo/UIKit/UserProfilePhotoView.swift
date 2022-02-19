//
//  UserProfilePhotoView.swift
//  iChatDemo
//
//  Created by Admin on 11.03.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import UIKit

class UserProfilePhotoView: UIView {
    
    let userPhoto: UIImageView = {
        var imageView = UIImageView(image: #imageLiteral(resourceName: "avatar"), contentMode: .scaleAspectFit)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let addPhotoButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        button.tintColor = .blackColor
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
     
        addSubview(userPhoto)
        addSubview(addPhotoButton)
        
        NSLayoutConstraint.activate([
            userPhoto.topAnchor.constraint(equalTo: topAnchor),
            userPhoto.leadingAnchor.constraint(equalTo: leadingAnchor),
            userPhoto.heightAnchor.constraint(equalToConstant: Constants.userProfilePhotoSize.width),
            userPhoto.widthAnchor.constraint(equalToConstant: Constants.userProfilePhotoSize.height),
            
            addPhotoButton.leadingAnchor.constraint(equalTo: userPhoto.trailingAnchor, constant: 16),
            addPhotoButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 30),
            addPhotoButton.widthAnchor.constraint(equalToConstant: 30),
            
            bottomAnchor.constraint(equalTo: userPhoto.bottomAnchor),
            trailingAnchor.constraint(equalTo: addPhotoButton.trailingAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userPhoto.layer.masksToBounds = true
        userPhoto.layer.cornerRadius = userPhoto.frame.width / 2
    }
}
