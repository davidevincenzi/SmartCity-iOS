//
//  IssueSelectorViewController.swift
//  SmartCity
//
//  Created by Salim Braksa on 1/29/18.
//  Copyright © 2018 Hidden Founders. All rights reserved.
//

import UIKit
import PromiseKit

class IssueSelectorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Views
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Data
    
    private var data = [IssueViewModel]()
    private var selectedIssueViewModel: IssueViewModel? {
        didSet {
            navigationItem.rightBarButtonItem?.isEnabled = selectedIssueViewModel != nil
        }
    }
    
    // MARK: Output
    
    var output = Promise<Issue?>.pending()
    
    // MARK: Config
    
    func setup(with issues: [Issue]) {
        self.data = issues.map { IssueViewModel(model: $0) }
    }
    
    // MARK: - Lifecycle
    
    override static func instantiate() -> IssueSelectorViewController {
        let name = String(describing: IssueSelectorViewController.self)
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name) as! IssueSelectorViewController
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBar = navigationController?.navigationBar
        navigationBar?.barTintColor = .black
        navigationBar?.tintColor = .white
        navigationBar?.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar?.isTranslucent = false
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "issue-cell", for: indexPath) as! SimilarIssueTableViewCell
        let viewModel = data[indexPath.row]
        cell.viewModel = viewModel
        cell.onCellTapped = { [unowned self] cell in
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            let vm = self.data[indexPath.row]
            vm.selected = true
            if let selectedIssueViewModel = self.selectedIssueViewModel, selectedIssueViewModel.model.id != vm.model.id {
                selectedIssueViewModel.selected = false
            }
            self.selectedIssueViewModel = vm
        }
        return cell
    }
    
    // MARK: -
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    // MARK: - User Interaction
    
    @IBAction func didClickDoneButton() {
        output.fulfill(selectedIssueViewModel?.model)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didClickCancelButton() {
        output.fulfill(nil)
        dismiss(animated: true, completion: nil)
    }
    
}
