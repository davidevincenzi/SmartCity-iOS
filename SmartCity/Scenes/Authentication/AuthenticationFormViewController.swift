//
//  AuthenticationFormViewController.swift
//  Tongo
//
//  Created by Salim Braksa on 7/29/17.
//  Copyright © 2017 Hidden Founders. All rights reserved.
//

import UIKit

class AuthenticationFormViewController: UIViewController {
    
    // MARK: - Views -
    
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - Constraints -
    
    @IBOutlet weak var mainStackViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainStackViewLeadingConstraint: NSLayoutConstraint!
    
    // MARK: - Properties -
    
    private lazy var keyboardHideManager: KeyboardHideManager = {
        let keyboardHideManager = KeyboardHideManager()
        keyboardHideManager.targets = [self.view]
        return keyboardHideManager
    }()
    
    // MARK: - View Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init
        let _ = keyboardHideManager
        
        // UI Customization
        submitButton.backgroundColor = UIColor(named: .PrimaryColor)
        for field in textFields {
            let placeholderAttributedString = NSMutableAttributedString(string: field.placeholder ?? "", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
            field.attributedPlaceholder = placeholderAttributedString
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let contentView = self.contentView {
            
            let minimumHeight = contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            let scale = min(1, view.bounds.height / minimumHeight)
            
            contentView.transform = CGAffineTransform(scaleX: scale, y: scale)
            contentView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
            
            mainStackViewLeadingConstraint.constant = 30 - contentView.frame.origin.x
            mainStackViewTrailingConstraint.constant = 30 - contentView.frame.origin.x
                        
        }
        
    }
    
}
