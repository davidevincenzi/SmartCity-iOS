//
//  PromiseKit+Additions.swift
//  Tongo
//
//  Created by Salim Braksa on 8/12/17.
//  Copyright © 2017 Hidden Founders. All rights reserved.
//

import PromiseKit

extension Promise {
    
    func map<U>(transform: @escaping (T) throws -> U) -> Promise<U> {
        
        return self.then { value in
            
            do {
                let transformedValue = try transform(value)
                return Promise<U>(value: transformedValue)
            } catch let error {
                print("Mapping to \(U.self) failed \(error)")
                throw error
            }
            
        }
        
    }
    
}
