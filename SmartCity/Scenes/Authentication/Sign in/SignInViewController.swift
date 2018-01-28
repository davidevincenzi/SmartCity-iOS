//
//  SignInViewController.swift
//  Tongo
//
//  Created by Salim Braksa on 7/29/17.
//  Copyright © 2017 Hidden Founders. All rights reserved.
//

import UIKit
import SwiftRichString

class SignInViewController: AuthenticationFormViewController {

    // MARK: - Views
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let signUpButtonLabel = signUpButton.titleLabel else { return }
        let parser = MarkupString(source: signUpButtonLabel.text ?? "", styles: [self.style(for: signUpButtonLabel)])
        let signUpButtonAttributedTitle = parser?.render()
        signUpButton.setAttributedTitle(signUpButtonAttributedTitle, for: .normal)
        
    }
    
    // MARK: - User Interaction
    
    @IBAction func didClickSignInButton(_ sender: UIButton) {
        
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""
        
        self.showSpinner()
        let service = AuthenticationServices()
        self.view.endEditing(true)
        service.signIn(withEmail: email, password: password).then { [weak self] user -> Void in
            
            guard let `self` = self else { return }
            
            let transition = ChildViewControllerSlideUpTransition()
            AppDelegate.shared.rootViewController.reload(with: transition)
            
        }.catch { [weak self] error in
            self?.show(error: error)
        }.always {
            self.hideSpinner()
        }

    }
    
    @IBAction func didClickSignUpButton(_ sender: UIButton) {
        tabBarController?.selectedIndex = 1
    }
    
    // MARK: - Helpers
    
    private func style(`for` label: UILabel) -> Style {
        
        let style = Style("c") {
            $0.font = FontAttribute(label.font.fontName, size: Float(label.font.pointSize))
            $0.color = UIColor(named: .PrimaryColor)
        }
        
        return style
        
    }

    
    
}
