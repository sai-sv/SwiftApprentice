//
//  HudView.swift
//  MyLocations
//
//  Created by Sergei Sai on 03.02.2022.
//

import Foundation
import UIKit

class HudView: UIView {
    var text = ""
    
    class func hud(inView view: UIView, animated: Bool) -> HudView {
        let hudView = HudView(frame: view.bounds)
        hudView.isOpaque = false
        
        view.addSubview(hudView)
        view.isUserInteractionEnabled = false
        
        //hudView.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        hudView.show(animated: animated)
        
        return hudView
    }
    
    override func draw(_ rect: CGRect) {
        let boxWidth: CGFloat = 96
        let boxHeight: CGFloat = 96
        
        let boxRect = CGRect(x: round((bounds.size.width - boxWidth) / 2),
                             y: round((bounds.size.height - boxHeight) / 2),
                             width: boxWidth, height: boxHeight)
        
        let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
        UIColor(white: 0.3, alpha: 0.8).setFill()
        roundedRect.fill()
        
        // Draw checkmark
        guard let image = UIImage(named: "Checkmark") else { return }
        let imagePoint = CGPoint(x: center.x - round(image.size.width / 2),
                                 y: center.y - round(image.size.width / 2) - boxHeight / 8)
        image.draw(at: imagePoint)
        
        // Draw the text
        let attribs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                       NSAttributedString.Key.foregroundColor: UIColor.white]
        let textSize = text.size(withAttributes: attribs)
        
        let textPoint = CGPoint(x: center.x - round(textSize.width / 2),
                                y: center.y - round(textSize.height / 2) + boxHeight / 4)
        text.draw(at: textPoint, withAttributes: attribs)
    }
    
    // MARK: - Helper methods
    func show(animated: Bool) {
        if !animated {
            return
        }
        
        alpha = 0
        transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        /*UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            self.transform = .identity
        }*/
        
        UIView.animate(withDuration: 0.3, delay: 0,
                       usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5,
                       options: [], animations: {
            self.alpha = 1
            self.transform = .identity
        }, completion: nil)

    }
    
    func hide() {
        superview?.isUserInteractionEnabled = true
        removeFromSuperview()
    }
}
