//
//  SessionServices.swift
//  Tongo
//
//  Created by Salim Braksa on 8/6/17.
//  Copyright © 2017 Hidden Founders. All rights reserved.
//

import Foundation
import RealmSwift

class SessionServices {
    
    private struct Keys {
        static let sessionKey = "session"
    }
    
    // MARK: - Static Properties
    
    static var current: Session?
    
    // MARK: - Saving Session
    
    func register(session: Session) {
        let realm = try! Realm()
        try? realm.write {
            realm.add(session, update: true)
        }
        SessionServices.current = session
    }
    
    // MARK: - Fetch
    
    func find() -> [Session] {
        return Array(try! Realm().objects(Session.self))
    }
    
    // MARK: - Restoration
    
    func restore(session: Session) throws {
        SessionServices.current = session
        if let user = UserRepository().findLocally(userId: session.userId) {
            User.current = user
        }
    }
    
    // MARK: - Remove
    
    func invalidateCurrentSession() {
        guard let session = SessionServices.current else { return }
        let realm = try! Realm()
        try? realm.write {
            realm.delete(session)
        }
        SessionServices.current = nil
    }
    
    // MARK: - Error
    
    struct Error {
        static let sessionRestorationFailure = NSError(source: SessionServices.self, message: "Unable to restore session")
    }
    
}
