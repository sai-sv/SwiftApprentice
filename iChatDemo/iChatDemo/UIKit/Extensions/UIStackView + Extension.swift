//
//  UIStackView + Extension.swift
//  iChatDemo
//
//  Created by Admin on 10.03.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import UIKit

extension UIStackView {
    
    convenience init(subviews: [UIView], axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat = 40) {
        self.init(arrangedSubviews: subviews)
        self.axis = axis
        self.spacing = spacing
    }
}
