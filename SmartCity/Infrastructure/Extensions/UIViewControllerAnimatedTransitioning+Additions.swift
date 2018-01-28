//
//  UIViewControllerAnimatedTransitioning+Additions.swift
//  Tongo
//
//  Created by Salim Braksa on 8/1/17.
//  Copyright © 2017 Hidden Founders. All rights reserved.
//

import UIKit

extension UIViewControllerAnimatedTransitioning {
    
    func setupTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            let destinationVC = transitionContext.viewController(forKey: .to)
            else { return }
        
        destinationVC.view.frame = transitionContext.finalFrame(for: destinationVC)
        transitionContext.containerView.addSubview(destinationVC.view)
        
    }
    
}
