//
//  User.swift
//  Realm Examples
//
//  Created by Joseph Quigley on 12/11/17.
//  Copyright © 2017 Joseph Quigley. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    let hobbies = List<Hobby>()
    @objc dynamic var deleted = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //Realm-safe id that will not throw exceptions when object is accessed after invalidation
    private(set) var safeId: String  = UUID().uuidString {
        didSet {
            if !isInvalidated {
                id = safeId
            }
        }
    }
}
