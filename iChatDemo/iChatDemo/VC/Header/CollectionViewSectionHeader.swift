//
//  CollectionViewSectionHeader.swift
//  iChatDemo
//
//  Created by Admin on 12.03.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import UIKit

class CollectionViewSectionHeader: UICollectionReusableView {
    
    static let reuseId = "CollectionViewSectionHeader"
    
    private let title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, font: UIFont?, textColor: UIColor) {
        self.title.text = title
        self.title.font = font
        self.title.textColor = textColor
    }
    
    private func setupConstraints() {
        
        title.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(title)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
