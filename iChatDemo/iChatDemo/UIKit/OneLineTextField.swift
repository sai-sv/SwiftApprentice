//
//  OneLineTextField.swift
//  iChatDemo
//
//  Created by Admin on 10.03.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import UIKit

class OneLineTextField: UITextField {
    
    convenience init(font: UIFont? = .avenirFont()) {
        self.init()

        self.borderStyle = .none
        self.font = font

        let line = UIView(frame: CGRect.zero)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .grayColor

        addSubview(line)

        NSLayoutConstraint.activate([
            line.heightAnchor.constraint(equalToConstant: 1),
            line.leadingAnchor.constraint(equalTo: leadingAnchor),
            line.trailingAnchor.constraint(equalTo: trailingAnchor),
            line.bottomAnchor.constraint(equalTo: bottomAnchor)

//            bottomAnchor.constraint(equalTo: line.bottomAnchor) // view can't calculate own size, do it manually!
        ])
    }
}
