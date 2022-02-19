//
//  UIImageView + Extension.swift
//  iChatDemo
//
//  Created by Admin on 10.03.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import UIKit

extension UIImageView {
    
    convenience init(image: UIImage?, contentMode: UIImageView.ContentMode) {
        self.init()
        
        self.image = image
        self.contentMode = contentMode
    }
    
    func setupColor(_ color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
