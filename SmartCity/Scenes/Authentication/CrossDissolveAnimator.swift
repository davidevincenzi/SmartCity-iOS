//
//  CrossDissolveAnimator.swift
//  Tongo
//
//  Created by Salim Braksa on 7/29/17.
//  Copyright © 2017 Hidden Founders. All rights reserved.
//

import UIKit

class CrossDissolveAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        setupTransition(using: transitionContext)
        
        // Access VCs
        let sourceVC = transitionContext.sourceViewController
        let destinationVC = transitionContext.destinationViewController
        
        // Animate
        let duration = self.transitionDuration(using: transitionContext)
        UIView.transition(from: sourceVC.view, to: destinationVC.view, duration: duration, options: .transitionCrossDissolve) { finished in
            transitionContext.completeTransition(true)
        }
        
    }
    
}
