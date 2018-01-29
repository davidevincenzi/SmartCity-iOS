//
//  SimilarIssueTableViewCell.swift
//  SmartCity
//
//  Created by Salim Braksa on 1/29/18.
//  Copyright © 2018 Hidden Founders. All rights reserved.
//

import UIKit

class SimilarIssueTableViewCell: UITableViewCell {
    
    var viewModel: IssueViewModel? {
        didSet {
            guard let viewModel = self.viewModel else { return }
            configure(using: viewModel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tintColor = UIColor(named: .PrimaryColor)
    }
    
    private func configure(using viewModel: IssueViewModel) {
        
        textLabel?.text = "Similar issue ID: \(viewModel.model.id)"
        
        viewModel.onSelectedChange = { selected in
            self.accessoryType = selected ? .checkmark : .none
        }
        
    }
    
}
