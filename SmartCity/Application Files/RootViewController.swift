//
//  RootViewController.swift
//  Tongo
//
//  Created by Salim Braksa on 7/29/17.
//  Copyright © 2017 Hidden Founders. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    // MARK: - Lifecycle
    
    override func loadView() {
        self.view = UIView()
        self.view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load(viewController: initialViewController())
    }
    
    // MARK: - Status Bar
    
    override var childViewControllerForStatusBarStyle: UIViewController? {
        return childViewControllers.last
    }
    
    // MARK: - Reloading
    
    func reload(with transition: UIViewControllerAnimatedTransitioning? = nil) {
        
        let currentChildViewController = childViewControllers.first
        let newViewController = initialViewController()
        load(viewController: newViewController, animated: transition != nil)
        
        // Perform transition if it's provided
        if let transition = transition {
            let context = ChildViewControllerContextTransitioning(source: currentChildViewController, destination: newViewController, container: self)
            transition.animateTransition(using: context)
        } else {
            currentChildViewController?.willMove(toParentViewController: nil)
            currentChildViewController?.view.removeFromSuperview()
            currentChildViewController?.removeFromParentViewController()
        }
        
        // Animate status bar change
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
        
    }
    
    // MARK: - Helpers
    
    private func initialViewController() -> UIViewController {
        
        if SessionServices.current != nil {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            return storyboard.instantiateInitialViewController()!
            
        } else {
            
            let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
            return storyboard.instantiateInitialViewController()!
            
        }
        
    }
    
    private func load(viewController: UIViewController, animated: Bool = false) {
        addChildViewController(viewController)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if !animated {
            view.addSubview(viewController.view)
            viewController.didMove(toParentViewController: self)
        }
    }
    
}
