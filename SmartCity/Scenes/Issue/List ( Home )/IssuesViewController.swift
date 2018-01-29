//
//  IssuesViewController.swift
//  SmartCity
//
//  Created by Salim Braksa on 1/28/18.
//  Copyright © 2018 Hidden Founders. All rights reserved.
//

import UIKit
import PromiseKit

class IssuesViewController: UIViewController, UITableViewDataSource {
    
    // MARK: Views
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullRefreshControl), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: Dependencies
    
    lazy var presenter: IssuesPresenterInput = {
        return IssuesPresenter(view: self)
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "issue-cell", for: indexPath) as! IssueTableViewCell
        presenter.configure(issueView: cell, at: indexPath)
        return cell
    }
    
    // MARK: - User Interaction
    
    @objc private func didPullRefreshControl() {
        presenter.didPullRefreshControl()
    }
    
    @IBAction private func didClickAddButton() {
        guard let user = User.current else { return }
        let imagePicker = UIImagePickerController()
        let imagePromise: Promise<UIImage> = promise(imagePicker)
        
        showSpinner()
        imagePromise.then { (image: UIImage) -> Promise<String> in
            return StorageServices().upload(image: image, by: user).map { $0.absoluteString }
        }.then { [unowned self] path -> Promise<String> in
            self.presenter.didEndTakingPicture(image: path)
            let viewController = IssueDescriptionEditingViewController.instantiate()
            let navigationController = UINavigationController(rootViewController: viewController)
            self.present(navigationController, animated: true, completion: nil)
            return viewController.promise
        }.then { [unowned self] description -> Void in
            self.presenter.didEndEditingDescription(description: description)
        }.always { [unowned self] in
            self.hideSpinner()
        }
        
    }
    
}

// MARK: -

extension IssuesViewController: IssuesViewInput {
    
    func update(withCityName city: String) {
        self.title = city.capitalized
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    func showActivity() {
        showSpinner()
    }
    
    func hideActivity() {
        hideSpinner()
    }
    
    func routeToIssueSelector(issues: [Issue]) {
        let viewController = IssueSelectorViewController.instantiate()
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.output.promise.then { issue -> Void in
            guard let issue = issue else { return }
            self.presenter.didEndSelectingParentIssue(issue: issue)
        }
        viewController.setup(with: issues)
        present(navigationController, animated: true, completion: nil)
    }

}

// MARK: -

protocol IssuesViewInput: class {
    
    func update(withCityName city: String)
    
    func reload()
    
    func endRefreshing()
    
    func showActivity()
    
    func hideActivity()
    
    func routeToIssueSelector(issues: [Issue])
    
}
