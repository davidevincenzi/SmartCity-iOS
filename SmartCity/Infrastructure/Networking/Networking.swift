//
//  Networking.swift
//  CompanyFeed
//
//  Created by salim on 1/21/17.
//  Copyright © 2017 hiddenfounders. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import Moya
import SwiftyJSON

struct Networking {
    
    typealias Provider = MoyaProvider<Backend>
    
    // MARK: - Sending Request
    
    @discardableResult
    static func request(target: Backend) -> Promise<JSON> {
        
        // Prepare promise
        let (promise, fulfill, reject) = Promise<JSON>.pending()
                
        // Perform request
        let provider = Provider(plugins: target.plugins)
        provider.request(target) { result in
            
            switch result {
            case .success(let response):
                do {
                    let json = try JSON(data: response.data)
                    fulfill(json)
                } catch let error {
                    reject(error)
                }
            case .failure(let error):
                reject(NSError(error))
            }
            
        }
        
        return promise
        
    }

}
