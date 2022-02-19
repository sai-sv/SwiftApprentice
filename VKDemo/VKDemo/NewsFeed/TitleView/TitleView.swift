//
//  TitleView.swift
//  VKDemo
//
//  Created by Admin on 27.02.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import Foundation
import UIKit

protocol TitleViewViewModel {
    var photoUrlString: String? { get }
}

class TitleView: UIView {
    
    private var searchTextField = SearchTextField()
    private var avatarView: WebImageView = {
        let view = WebImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(searchTextField)
        addSubview(avatarView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarView.layer.masksToBounds = true
        avatarView.layer.cornerRadius = avatarView.frame.height / 2
    }
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    func set(viewModel: TitleViewViewModel) {
        avatarView.set(imageURL: viewModel.photoUrlString)
    }
    
    private func setupConstraints() {
        
        avatarView.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        avatarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 4).isActive = true
        avatarView.heightAnchor.constraint(equalTo: searchTextField.heightAnchor, multiplier: 1).isActive = true
        avatarView.widthAnchor.constraint(equalTo: searchTextField.heightAnchor, multiplier: 1).isActive = true
        
        searchTextField.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        searchTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: avatarView.leadingAnchor, constant: -12).isActive = true
    }
}
