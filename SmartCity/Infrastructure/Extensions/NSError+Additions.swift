//
//  NSError+Additions.swift
//  Tongo
//
//  Created by Salim Braksa on 9/26/17.
//  Copyright © 2017 Hidden Founders. All rights reserved.
//

import Foundation
import Moya

extension MoyaError {
    
    static let domain = "MoyaErrorDomain"
    
}

extension NSError {
    
    static var unknownError: NSError {
        return NSError(domain: "UnknownErroDomain", code: -1, userInfo: nil)
    }
    
    static var cancellationError: NSError {
        return NSError(domain: "CancellationError", code: 999, userInfo: nil)
    }
    
    convenience init(_ moyaError: MoyaError) {

        switch moyaError {
        case .underlying(let error, _):
            let nserror = error as NSError
            self.init(domain: nserror.domain, code: nserror.code, userInfo: nserror.userInfo)
        default:
            self.init(domain: MoyaError.domain, code: -1, userInfo: [NSLocalizedDescriptionKey: moyaError.localizedDescription])
        }
        
    }
    
    convenience init<T>(source: T.Type, message: String) {
        let domain = "\(source)ErrorDomain"
        self.init(domain: domain, code: -1, userInfo: [NSLocalizedDescriptionKey: message])
    }
    
    static func ==(left: NSError, right: NSError) -> Bool {
        return (left.domain, left.code) == (right.domain, right.code)
    }
    
}
