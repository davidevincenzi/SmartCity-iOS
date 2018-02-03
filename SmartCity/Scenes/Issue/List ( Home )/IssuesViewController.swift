//
//  IssuesViewController.swift
//  SmartCity
//
//  Created by Salim Braksa on 1/28/18.
//  Copyright © 2018 Hidden Founders. All rights reserved.
//

import UIKit
import PromiseKit

extension UINavigationController {
    
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return childViewControllers.last
    }
    
}

class IssuesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
        
        let navigationBar = navigationController?.navigationBar
        navigationBar?.barTintColor = .black
        navigationBar?.tintColor = .white
        navigationBar?.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar?.isTranslucent = false
        
        presenter.viewDidLoad()
        tableView.insertSubview(refreshControl, at: 0)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "issue-cell", for: indexPath) as! IssueTableViewCell
        presenter.configure(issueView: cell, at: indexPath)
        
        cell.didToggleConfirmButton = { [unowned self] cell in
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            self.presenter.didToggleConfirmButton(at: indexPath)
        }
        
        cell.didTriggerLongPress = { [unowned self] cell in
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let maps = UIAlertAction(title: "View in Maps", style: .default, handler: { (_) in
                guard let indexPath = self.tableView.indexPath(for: cell) else { return }
                self.presenter.didClickViewInMaps(at: indexPath)
            })
            alertController.addAction(cancel)
            alertController.addAction(maps)
            self.present(alertController, animated: true, completion: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    // MARK: - User Interaction
    
    @objc private func didPullRefreshControl() {
        presenter.didPullRefreshControl()
    }
    
    @IBAction private func didClickAddButton() {
        guard let user = User.current else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
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
