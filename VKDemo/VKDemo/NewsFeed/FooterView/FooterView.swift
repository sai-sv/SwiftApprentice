//
//  FooterView.swift
//  VKDemo
//
//  Created by Admin on 02.03.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import Foundation
import UIKit

class FooterView: UIView {
    
    private var label: UILabel = {
        
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.631372549, green: 0.6470588235, blue: 0.662745098, alpha: 1)
        return label
    }()
    
    private var indicator: UIActivityIndicatorView = {
        var indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        addSubview(indicator)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        label.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        indicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        indicator.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8).isActive = true
    }
    
    func showIndicator() {
        indicator.startAnimating()
    }
    
    func setTitle(title: String?) {
        label.text = title
        indicator.stopAnimating()
    }
}
