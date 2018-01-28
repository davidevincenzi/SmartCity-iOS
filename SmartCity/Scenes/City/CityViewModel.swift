//
//  CityViewModel.swift
//  SmartCity
//
//  Created by Salim Braksa on 1/28/18.
//  Copyright © 2018 Hidden Founders. All rights reserved.
//

import Foundation

class CityViewModel {
    
    let name: String
    
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
    
    init(cityName: String) {
        self.name = cityName.capitalized
    }
    
}
