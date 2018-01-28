//
//  AuthenticationTabBarController.swift
//  Tongo
//
//  Created by Salim Braksa on 7/29/17.
//  Copyright © 2017 Hidden Founders. All rights reserved.
//

import UIKit

class AuthenticationTabBarController: UITabBarController, UITabBarControllerDelegate {

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "auth_bg"))
        imageView.frame = view.bounds
        imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.insertSubview(imageView, at: 0)
        
        delegate = self
        
    }
    
    // MARK: - Status Bar Style
    
    override var childViewControllerForStatusBarStyle: UIViewController? {
        return nil
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - UITabBarControllerDelegate Protocol Methods
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CrossDissolveAnimator()
    }
    
}
