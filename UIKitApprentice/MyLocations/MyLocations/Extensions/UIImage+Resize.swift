//
//  UIImage+Resize.swift
//  MyLocations
//
//  Created by Sergei Sai on 05.02.2022.
//

import Foundation
import UIKit

extension UIImage {
    
    func resized(withBounds bounds: CGSize) -> UIImage {
        let horizontalRatio = bounds.width / size.width
        let verticalRation = bounds.height / size.height
        let ratio = min(horizontalRatio, verticalRation)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
