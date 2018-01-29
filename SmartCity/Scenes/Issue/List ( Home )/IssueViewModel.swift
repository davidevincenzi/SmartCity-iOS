//
//  IssueViewModel.swift
//  SmartCity
//
//  Created by Salim Braksa on 1/28/18.
//  Copyright © 2018 Hidden Founders. All rights reserved.
//

import Foundation

class IssueViewModel {
    
    let model: Issue
    
    var onSelectedChange: ((Bool) -> ())? {
        didSet {
            onSelectedChange?(selected)
        }
    }
    
    var selected = false {
        didSet {
            onSelectedChange?(selected)
        }
    }
    
    init(model: Issue) {
        self.model = model
    }
    
}
