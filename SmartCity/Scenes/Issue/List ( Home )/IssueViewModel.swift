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
    
    var confirms = 0 {
        didSet {
            onConfirmsCountChange?(confirms)
        }
    }
    
    var onSelectedChange: ((Bool) -> ())? {
        didSet {
            onSelectedChange?(selected)
        }
    }
    
    var onConfirmedChange: ((Bool) -> ())? {
        didSet {
            onConfirmedChange?(confirmed)
        }
    }
    
    var onConfirmsCountChange: ((Int) -> ())? {
        didSet {
            onConfirmsCountChange?(confirms)
        }
    }
    
    var confirmed = false
    var selected = false {
        didSet {
            onSelectedChange?(selected)
        }
    }
    
    func set(confirmed: Bool, notify: Bool = true) {
        self.confirmed = confirmed
        if notify {
            onConfirmedChange?(confirmed)
        }
    }
    
    init(model: Issue) {
        self.model = model
        self.confirms = model.confirms
        self.set(confirmed: model.confirmed, notify: false)
    }
    
}
