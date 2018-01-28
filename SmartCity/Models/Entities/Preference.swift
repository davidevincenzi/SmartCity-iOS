//
//  Preference.swift
//  SmartCity
//
//  Created by Salim Braksa on 1/28/18.
//  Copyright © 2018 Hidden Founders. All rights reserved.
//

import Foundation

class Preference: NSObject {
    
    @objc dynamic var city = "rabat"
    
    static var current = Preference()
    
    private override init() {
        super.init()
    }
    
}
