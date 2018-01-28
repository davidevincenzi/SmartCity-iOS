//
//  Validation.swift
//  Tongo
//
//  Created by Salim Braksa on 11/13/17.
//  Copyright © 2017 Hidden Founders. All rights reserved.
//

import Foundation

struct ValidationError {
    let field: String
    let message: String
}

typealias Validator<T> = (T) -> Bool
