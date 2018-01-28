//
//  IssueTableViewCell.swift
//  SmartCity
//
//  Created by Salim Braksa on 1/28/18.
//  Copyright © 2018 Hidden Founders. All rights reserved.
//

import UIKit

class IssueTableViewCell: UITableViewCell, IssueViewInput {

    var viewModel: IssueViewModel? {
        didSet {
            guard let viewModel = self.viewModel else { return }
            configure(using: viewModel)
        }
    }
    
    // MARK: -
    
    func configure(using viewModel: IssueViewModel) {
        textLabel?.text = "Issue ID: \(viewModel.model.id)"
    }

}

// MARK: -

protocol IssueViewInput: class {
    
    var viewModel: IssueViewModel? { get set }
    
}
