//
//  String + Height.swift
//  VKDemo
//
//  Created by Admin on 04.02.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func height(width: CGFloat, font: UIFont) -> CGFloat {
        
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        let rect = self.boundingRect(with: size,
                          options: .usesLineFragmentOrigin,
                          attributes: [NSAttributedString.Key.font: font],
                          context: nil)
                
        return ceil(rect.height)
    }
}
