//
//  UIViewController+Additions.swift
//  Tongo
//
//  Created by Salim Braksa on 7/29/17.
//  Copyright © 2017 Hidden Founders. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON

extension UIViewController {
    
    // MARK: - Init
    
    @objc class func instantiate() -> Self {
        fatalError("Requires implementation by subclasses")
    }
    
    // MARK: - Segue
    
    func performSegue(withIdentifier identifier: String, configuration: (UIViewController) -> ()) {
        performSegue(withIdentifier: identifier, sender: configuration)
    }
    
    // MARK: - Error
    
    func show(error: Error) {
        
        // Read from 'errors.plist'
        let error = error as NSError
        let errorsPath = Bundle.main.path(forResource: "errors", ofType: "plist")!
        let errorsDictionary = (NSDictionary(contentsOfFile: errorsPath) as? [String: Any]) ?? [:]
        let errors = JSON(errorsDictionary)
        
        // Read description
        let description: String
        if let unwrappedDescription = errors[error.domain].dictionary?["\(error.code)"]?.string {
            description = unwrappedDescription
        } else if let _ = errors[error.domain].string {
            description = error.localizedDescription
        } else {
            description = "The application has encountered an unknown error."
        }
        
        // Show error
        let alertController = UIAlertController(title: "Oops!", message: description, preferredStyle: .alert)
        let close = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        alertController.addAction(close)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let close = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        alertController.addAction(close)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Spinner
    
    @discardableResult
    func showSpinner(type: SpinnerType = .default) -> MBProgressHUD {
        
        let viewController = parent ?? self
        let hud = MBProgressHUD.showAdded(to: viewController.view, animated: true)
        
        switch type {
        case .success:
            hud.mode = .customView
            hud.customView = UIImageView(image: #imageLiteral(resourceName: "hud-checkmark"))
            hud.label.text = "Done"
            hud.isSquare = true
            hud.isUserInteractionEnabled = false
        default: break
        }
        
        return hud
        
    }
    
    func hideSpinner() {
        let viewController = parent ?? self
        MBProgressHUD.hide(for: viewController.view, animated: true)
    }
    
    // MARK: Types
    
    enum SpinnerType {
        
        case `default`
        case success
        
    }
    
    // MARK: - IBActions
    
    @IBAction func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
