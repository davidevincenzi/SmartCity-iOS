//
//  Session.swift
//  Tongo
//
//  Created by Salim Braksa on 8/6/17.
//  Copyright © 2017 Hidden Founders. All rights reserved.
//

import RealmSwift

class Session: Object {
    
    @objc dynamic var id = 0
    
    @objc dynamic var userId: Int = -1
    @objc dynamic var authToken: String = ""
    
    override class func primaryKey() -> String {
        return "id"
    }
    
}
