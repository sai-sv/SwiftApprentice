//
//  GalleryCollecionViewCell.swift
//  VKDemo
//
//  Created by Admin on 13.02.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import Foundation
import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "GalleryCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive =  true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private let imageView: WebImageView = {
       let view = WebImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.backgroundColor = #colorLiteral(red: 0.9209702795, green: 0.9209702795, blue: 0.9209702795, alpha: 1)
        return view
    }()
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        self.layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 2.5, height: 4)
    }
    
    func set(url: String?) {
        imageView.set(imageURL: url)
    }
}
