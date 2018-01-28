//
//  Backend.swift
//  CompanyFeed
//
//  Created by Salim Braksa on 3/12/17.
//  Copyright © 2017 hiddenfounders. All rights reserved.
//

import Moya
import SwiftyJSON
import CoreLocation

enum Backend {
    
    // Authentication
    case signIn(email: String, password: String)
    case signUp(JSON)
    
    // Issues
    case findIssues(String)
    case findSimilarIssues(CLLocationCoordinate2D)
    case createIssue(CreateIssueParams)
    
}

extension Backend: TargetType {
    
    var baseURL: URL {
        return URL(string: "http://192.168.8.100:3000")!
    }
    
    var path: String {
        switch self {
        case .signIn(_, _): return "/auth/sign_in"
        case .signUp: return "/auth/sign_up"
        case .findIssues: return "/issues"
        case .createIssue, .findSimilarIssues: return "/issues"
        }
    }
    var method: Moya.Method {
        
        switch self {
        case .signIn, .signUp,
             .createIssue:
            return .post
        case  .findIssues, .findSimilarIssues:
            return .get
        }
        
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .signIn(let email, let password):
            return ["auth": ["email": email, "password": password]]
        case .signUp(let params):
            return params.dictionaryObject
        case .findIssues(let city):
            return ["city": city.lowercased()]
        case .createIssue(let params):
            return params.toJSON()
        case .findSimilarIssues(let coordinate):
            return ["latitude": coordinate.latitude, "longitude": coordinate.longitude]
        }
        
    }
    
    var validate: Bool {
        return true
    }
    
    var parameterEncoding: ParameterEncoding {
        
        switch self.method {
        case .get: return URLEncoding.default
        default: return JSONEncoding.default
        }

    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        
        if let params = parameters {
            return .requestParameters(parameters: params, encoding: parameterEncoding)
        } else {
            return .requestPlain
        }
        
    }
    
    var headers: [String: String]? {
        
        switch self {
        case .signIn, .signUp: return nil
        default: return ["Authorization": token ?? ""]
        }
        
    }
    
    var plugins: [PluginType] {
        return [NetworkPlugin(), NetworkLoggerPlugin()]
    }
    
}

