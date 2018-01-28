//
//  ChildViewControllerSlideUpTransition.swift
//  Tongo
//
//  Created by Salim Braksa on 8/6/17.
//  Copyright © 2017 Hidden Founders. All rights reserved.
//

import UIKit

class ChildViewControllerSlideUpTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // Setup
        let destination = transitionContext.destinationViewController
        let source = transitionContext.viewController(forKey: .from)
        transitionContext.containerView.addSubview(destination.view)
        
        // Animation
        destination.view.transform = CGAffineTransform(translationX: 0, y: destination.view.bounds.height)
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            destination.view.transform = .identity
        }) { finished in
            source?.willMove(toParentViewController: nil)
            source?.view.removeFromSuperview()
            source?.removeFromParentViewController()
            transitionContext.completeTransition(finished)
        }
        
    }
    
}
