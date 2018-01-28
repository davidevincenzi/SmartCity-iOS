//
//  CityTableViewCell.swift
//  SmartCity
//
//  Created by Salim Braksa on 1/28/18.
//  Copyright © 2018 Hidden Founders. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    
    var viewModel: CityViewModel? {
        didSet {
            if let viewModel = viewModel {
                configure(using: viewModel)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tintColor = UIColor(named: .PrimaryColor)
    }
    
    private func configure(using viewModel: CityViewModel) {
        
        textLabel?.text = viewModel.name
        
        viewModel.onSelectedChange = { [unowned self] selected in
            self.accessoryType = selected ? .checkmark : .none
        }
        
    }
    
}

