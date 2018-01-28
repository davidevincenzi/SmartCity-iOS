//
//  Issue.swift
//  SmartCity
//
//  Created by Salim Braksa on 1/28/18.
//  Copyright © 2018 Hidden Founders. All rights reserved.
//

import ObjectMapper

class Issue: ImmutableMappable {
    
    var id: Int = -1
    
    // MARK: -
    
    required init(map: Map) throws {
        self.id = try map.value("id")
    }
    
    func mapping(map: Map) {
        
    }
    
}
