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
    var samples = [IssueSample]()
    var confirms = 0
    var confirmed = false
    
    // MARK: -
    
    required init(map: Map) throws {
        self.id = try map.value("id")
        self.samples = try map.value("samples")
        self.confirms = try map.value("confirms")
        self.confirmed = try map.value("confirmed")
    }
    
    func mapping(map: Map) {
        
    }
    
}

class IssueSample: ImmutableMappable {
    
    var description: String = ""
    var image: String = ""
    
    required init(map: Map) throws {
        self.description = map.value("description", default: "")
        self.image = map.value("image", default: "")
    }
    
    func mapping(map: Map) {
        
    }
    
}
