//
//  SignUpViewController.swift
//  Tongo
//
//  Created by Salim Braksa on 7/29/17.
//  Copyright © 2017 Hidden Founders. All rights reserved.
//

import UIKit
import SwiftRichString

class SignUpViewController: AuthenticationFormViewController {
    
    // MARK: - Views
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let signInButtonLabel = signInButton.titleLabel else { return }
        let parser = MarkupString(source: signInButtonLabel.text ?? "", styles: [self.style(for: signInButtonLabel)])
        let signUpButtonAttributedTitle = parser?.render()
        signInButton.setAttributedTitle(signUpButtonAttributedTitle, for: .normal)
        
    }
    
    // MARK: - User Interaction
    
    @IBAction func didClickSignInButton(_ sender: UIButton) {
        tabBarController?.selectedIndex = 0
    }
    
    @IBAction func didClickSignUpButton(_ sender: UIButton) {
        
        let name = nameField.text ?? ""
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""
        let formValues = UserCredentialsFormValues(username: name, email: email, password: password)
        
        let validationErrors = formValues.validate()
        if let error = validationErrors.first {
            self.showAlert(title: error.field.capitalized, message: error.message)
            return
        }
        
        self.showSpinner()
        let service = AuthenticationServices()
        self.view.endEditing(true)
        service.signUp(withName: name, email: email, password: password).then { [weak self] user -> Void in
            
            guard let `self` = self else { return }
            
            self.view.endEditing(true)
            let transition = ChildViewControllerSlideUpTransition()
            AppDelegate.shared.rootViewController.reload(with: transition)
            
        }.catch { [weak self] error in
            self?.show(error: error)
        }.always {
            self.hideSpinner()
        }
        
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

// MARK: -

private struct UserCredentialsFormValues {
    
    let username: String
    let email: String
    let password: String
    
    init(username: String, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = password
    }
    
    func validate() -> [ValidationError] {
        
        var errors = [ValidationError]()
        
        // Email validation
        let emailValidator = EmailValidator()
        let isEmailValid = emailValidator.isValid(email: email)
        if !isEmailValid {
            errors.append(ValidationError(field: Field.email, message: "Please enter a valid email address"))
        }
        
        return errors
        
    }
    
    struct Field {
        static let email = "email"
    }
    
}
