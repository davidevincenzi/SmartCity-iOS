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
    private var selectedIssueViewModel: IssueViewModel?
    
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
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "issue-cell", for: indexPath) as! SimilarIssueTableViewCell
        cell.viewModel = data[indexPath.row]
        return cell
    }
    
    // MARK: -
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedIssueViewModel?.selected = false
        let newSelectedCityViewModel = data[indexPath.row]
        newSelectedCityViewModel.selected = true
        self.selectedIssueViewModel = newSelectedCityViewModel
        
    }
    
    // MARK: - User Interaction
    
    @IBAction func didClickDoneButton() {
        if let issue = selectedIssueViewModel?.model {
            output.fulfill(issue)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didClickCancelButton() {
        output.fulfill(nil)
        dismiss(animated: true, completion: nil)
    }
    
}
