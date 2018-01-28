//
//  FindIssuesUseCase.swift
//  SmartCity
//
//  Created by Salim Braksa on 1/28/18.
//  Copyright © 2018 Hidden Founders. All rights reserved.
//

import PromiseKit

class FindIssuesUseCase: FindIssuesUseCaseInput {
    
    func find(inCity city: String) -> Promise<[Issue]> {
        return Networking.request(target: .findIssues(city)).map { try Issue.collection(from: $0) }
    }
    
}

// MARK: -

protocol FindIssuesUseCaseInput {
    
    func find(inCity city: String) -> Promise<[Issue]>
    
}
