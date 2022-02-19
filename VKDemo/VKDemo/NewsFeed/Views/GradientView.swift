//
//  GradientView.swift
//  VKDemo
//
//  Created by Admin on 03.03.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import Foundation
import UIKit

class GradientView: UIView {
    
    private var gradiendLayer = CAGradientLayer()
    
    @IBInspectable private var startColor: UIColor? {
        didSet {
            setupGradientColors()
        }
    }
    
    @IBInspectable private var endColor: UIColor? {
        didSet {
            setupGradientColors()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupGradientLayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradiendLayer.frame = bounds
    }
    
    private func setupGradientColors() {
        guard let startColor = self.startColor?.cgColor, let endColor = self.endColor?.cgColor else {
            return
        }
        gradiendLayer.colors = [startColor, endColor]
    }
    
    private func setupGradientLayer() {
        layer.addSublayer(gradiendLayer)
        gradiendLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradiendLayer.endPoint = CGPoint(x: 0.5, y: 1)
        setupGradientColors()
    }
}

