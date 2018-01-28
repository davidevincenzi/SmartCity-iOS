//
//  ObjectMapper+Additions.swift
//  Tongo
//
//  Created by Salim Braksa on 6/17/17.
//  Copyright © 2017 Hidden Founders. All rights reserved.
//

import ObjectMapper
import SwiftyJSON

extension ImmutableMappable {
    
    init(json: JSON) throws {
        try self.init(JSONString: json.description)
    }
    
    static func collection(from json: JSON) throws -> [Self] {
        
        var objects = [Self]()
        
        guard let array = json.array else {
            let _ = try Self.init(json: JSON([:])) // Trigger exception
            return []
        }
        
        for json in array {
            objects.append(try Self.init(json: json))
        }
        return objects
        
    }
    
}

extension Map {
    
    func value<T>(_ key: String, default: T) -> T {
        let value: T = (try? self.value(key)) ?? `default`
        return value
    }
    
}
