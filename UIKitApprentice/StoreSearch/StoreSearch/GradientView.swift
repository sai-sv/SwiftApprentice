//
//  GradientView.swift
//  StoreSearch
//
//  Created by Sergei Sai on 12.02.2022.
//

import Foundation
import UIKit

class GradientView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        let color: CGFloat = UITraitCollection.current.userInterfaceStyle == .light ? 0.314 : 1
        let components: [CGFloat] = [
            color, color, color, 0.2,
            color, color, color, 0.4,
            color, color, color, 0.6,
            color, color, color, 1.0
        ]
        let locations: [CGFloat] = [0.0, 0.5, 0.75, 1.0]
        
        let x = bounds.midX
        let y = bounds.midY
        let center = CGPoint(x: x, y: y)
        let radius = max(x, y)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorSpace: colorSpace,
                                  colorComponents: components,
                                  locations: locations,
                                  count: 4)
        
        let context = UIGraphicsGetCurrentContext()
        context?.drawRadialGradient(gradient!,
                                    startCenter: center,
                                    startRadius: 0,
                                    endCenter: center,
                                    endRadius: radius,
                                    options: .drawsAfterEndLocation)
    }
}
