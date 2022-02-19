//
//  SlideOutAnimationController.swift
//  StoreSearch
//
//  Created by Sergei Sai on 12.02.2022.
//

import Foundation
import UIKit

class SlideOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let fromView = transitionContext.view(forKey: .from) {
            let containerView = transitionContext.containerView
            let time = transitionDuration(using: transitionContext)
            
            UIView.animate(withDuration: time, delay: 0,
                           options: .curveEaseIn) {
                fromView.center.y -= containerView.bounds.size.height
                fromView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            } completion: { finished in
                transitionContext.completeTransition(finished)
            }
        }
    }
    
}
