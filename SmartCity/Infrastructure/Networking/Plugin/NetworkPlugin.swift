//
//  NetworkPlugin.swift
//  CompanyFeed
//
//  Created by Salim Braksa on 3/18/17.
//  Copyright © 2017 hiddenfounders. All rights reserved.
//

import Moya
import SwiftyJSON
import Result
import ObjectMapper

struct NetworkPlugin: PluginType {
    
    func prepare( _ request: URLRequest, target: TargetType) -> URLRequest {
        return request
    }
    
    func willSend(_ request: RequestType, target: TargetType) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        
        switch result {
        case .success: return result
        case .failure(let moyaError):
            
            guard let response = moyaError.response else { return result }
            
            // Map Data to JSON
            var json = JSON(response.data)
            if json.null != nil {
                json = [:]
            }
            
            // Map json to NSError
            do {
                let error = try NSError(MappableError(json: json["error"]))
                let result = Result<Response, MoyaError>(error: MoyaError.underlying(error, response))
                return result
            } catch _ {
                return result
            }
            
        }
        
    }
    
}

private class MappableError: ImmutableMappable {
    
    let domain: String
    let code: Int
    
    required init(map: Map) throws {
        domain = try map.value("domain")
        code = try map.value("code")
    }
    
    func mapping(map: Map) {
    }
    
}

extension NSError {
    
    convenience fileprivate init(_ error: MappableError) {
        self.init(domain: error.domain, code: error.code, userInfo: nil)
    }
    
}
