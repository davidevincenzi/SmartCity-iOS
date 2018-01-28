//
//  User.swift
//  Tongo
//
//  Created by Salim Braksa on 8/2/17.
//  Copyright © 2017 Hidden Founders. All rights reserved.
//

import ObjectMapper
import RealmSwift

class User: Object, ImmutableMappable {
    
    // MARK: - Properties
    
    @objc dynamic var id: Int = -1
    @objc dynamic var name: String = ""
    @objc dynamic var email: String = ""
    
    static var current: User? = nil
        
    // MARK: - Realm
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    // MARK: - Mapping
    
    func toJSON() -> [String : Any] {
        return ["email": email, "name": name]
    }
    
    convenience required init(map: Map) throws {
        self.init()
    }
    
    func mapping(map: Map) {
        self.name = (try? map.value("name")) ?? ""
        self.email = (try? map.value("email")) ?? ""
        self.id = (try? map.value("id")) ?? -1
    }
    
}

