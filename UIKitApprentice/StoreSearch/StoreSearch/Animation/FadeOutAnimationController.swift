//
//  FadeOutAnimationController.swift
//  StoreSearch
//
//  Created by Sergei Sai on 13.02.2022.
//

import Foundation
import UIKit

class FadeOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let fromView = transitionContext.view(forKey: .from) {
            let time = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: time, delay: 0) {
                fromView.alpha = 0
            } completion: { finished in
                transitionContext.completeTransition(finished)
            }
        }
    }
    
}
