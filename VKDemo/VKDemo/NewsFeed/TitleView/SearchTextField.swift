//
//  SearchTextField.swift
//  VKDemo
//
//  Created by Admin on 27.02.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import Foundation
import UIKit

class SearchTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        font = .systemFont(ofSize: 14)
        placeholder = "Поиск"
        borderStyle = .none
        clearButtonMode = .always
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = #colorLiteral(red: 0.964407519, green: 0.964407519, blue: 0.964407519, alpha: 1)
        
        let image = UIImage(named: "search")
        leftView = UIImageView(image: image)
        leftView?.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        leftViewMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 12
        return rect
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
}
