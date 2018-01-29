//
//  EditTodoViewController.swift
//  Todo
//
//  Created by Salim Braksa on 10/18/17.
//  Copyright © 2017 Hidden Founders. All rights reserved.
//

import UIKit
import PromiseKit
import IQKeyboardManagerSwift

class IssueDescriptionEditingViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - Views
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewPlaceholderLabel: UILabel!
    
    // MARK: - Callbacks
    
    var (promise, fulfill, reject) = Promise<String>.pending()
    
    // MARK: - Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        IQKeyboardManager.sharedManager().disabledDistanceHandlingClasses.append(IssueDescriptionEditingViewController.self)
    }
    
    override static func instantiate() -> IssueDescriptionEditingViewController {
        let name = String(describing: IssueDescriptionEditingViewController.self)
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name) as! IssueDescriptionEditingViewController
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup textView UI
        textView.becomeFirstResponder()
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    // MARK: - User Interaction
    
    private func didClickCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didClickSaveButton() {
        fulfill(textView.text ?? "")
        didClickCancelButton()
    }
    
    // MARK: - UITextViewDelegate Protocol Methods
    
    func textViewDidChange(_ textView: UITextView) {
        let shouldHidePlaceholderLabel = !textView.text.isEmpty
        if shouldHidePlaceholderLabel != textViewPlaceholderLabel.isHidden {
            textViewPlaceholderLabel.isHidden = shouldHidePlaceholderLabel
        }
    }
    
}
