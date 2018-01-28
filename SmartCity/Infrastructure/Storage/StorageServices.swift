//
//  StorageServices.swift
//  Tongo
//
//  Created by Salim Braksa on 9/11/17.
//  Copyright © 2017 Hidden Founders. All rights reserved.
//

import UIKit
import PromiseKit
import FirebaseStorage

class StorageServices {
    
    func upload(image: UIImage, path: String = "", name: String) -> Promise<URL> {
        
        let (promise, fulfill, reject) = Promise<URL>.pending()
        
        guard let data = UIImageJPEGRepresentation(image, 0) else { reject(NSError(domain: "", code: -1, userInfo: nil)); return promise }
        let path = "images/\(path)/\(name).jpeg"
        
        // Do the actual uploading
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child(path)

        imageRef.putData(data, metadata: nil) { (metadata, error) in
            
            if let error = error {
                reject(error)
            } else if let url = metadata?.downloadURL() {
                fulfill(url)
            } else {
                reject(NSError())
            }
            
        }
        
        return promise
        
    }
    
    func upload(image: UIImage, by user: User) -> Promise<URL> {
        let path = "user_\(user.id)"
        let name = UUID().uuidString
        return upload(image: image, path: path, name: name)
    }
    
}
