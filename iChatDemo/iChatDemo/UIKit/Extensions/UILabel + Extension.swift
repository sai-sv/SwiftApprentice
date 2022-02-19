//
//  UILabel + Extension.swift
//  iChatDemo
//
//  Created by Admin on 10.03.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont? = .avenirFont()) {
        self.init()
        
        self.text = text
        self.font = font
    }
}
