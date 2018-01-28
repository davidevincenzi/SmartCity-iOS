//
//  UIViewControllerContextTransitioning+Additions.swift
//  Tongo
//
//  Created by Salim Braksa on 8/1/17.
//  Copyright © 2017 Hidden Founders. All rights reserved.
//

import UIKit

extension UIViewControllerContextTransitioning {
    
    var destinationViewController: UIViewController {
        return viewController(forKey: .to)!
    }
    
    var sourceViewController: UIViewController {
        return viewController(forKey: .from)!
    }
    
}
