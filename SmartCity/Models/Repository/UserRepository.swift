//
//  BusinessRepository.swift
//  Tongo
//
//  Created by Salim Braksa on 9/24/17.
//  Copyright © 2017 Hidden Founders. All rights reserved.
//

import RealmSwift
import PromiseKit

class UserRepository {
    
    func findLocally(userId: Int) -> User? {
        let realm = try! Realm()
        return realm.object(ofType: User.self, forPrimaryKey: userId)
    }
    
    func saveLocally(user: User) {
        let realm = try? Realm()
        try? realm?.write {
            realm?.add(user, update: true)
        }
    }
    
}
