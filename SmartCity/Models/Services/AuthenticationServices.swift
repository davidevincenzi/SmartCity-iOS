//
//  BusinessAuthenticationServices.swift
//  Tongo
//
//  Created by Salim Braksa on 8/2/17.
//  Copyright © 2017 Hidden Founders. All rights reserved.
//

import PromiseKit
import SwiftyJSON

class AuthenticationServices {

    // MARK: - Sign In

    func signIn(withEmail email: String, password: String) -> Promise<User> {
        
        let target: Backend = .signIn(email: email, password: password)
        let promise = Networking.request(target: target)

        return processAuthenticationPromise(promise)

    }

    // MARK: - Sign Up

    func signUp(withName name: String, email: String, password: String) -> Promise<User> {

        let params: JSON = ["user": ["name": name, "email": email, "password": password, "password_confirmation": password]]
        let target: Backend = .signUp(params)
        let promise = Networking.request(target: target)

        return processAuthenticationPromise(promise)

    }

    // MARK: - Sign Out

    func signOut() {
        SessionServices().invalidateCurrentSession()
    }

    // MARK: - Helpers

    /// Maps JSON to User then persist the user.
    private func processAuthenticationPromise(_ promise: Promise<JSON>) -> Promise<User> {

        return promise.then { json -> Promise<User> in

            do {

                let user = try User(json: json)
                let token = json["token"].string
                User.current = user
                let session = Session()
                session.authToken = token ?? ""
                session.userId = user.id
                SessionServices().register(session: session)
                
                UserRepository().saveLocally(user: user)
                
                return Promise<User>(value: user)
                
            } catch let error {
                return Promise(error: error)
            }

        }

    }

}

