//
//  User+ListDiffable.swift
//  Realm Examples
//
//  Created by Joseph Quigley on 12/11/17.
//  Copyright © 2017 Joseph Quigley. All rights reserved.
//

import IGListKit

extension User: ListDiffable {
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? User else {
            return false
        }
        return object.safeId == safeId &&
            object.firstName == firstName &&
            object.lastName == lastName &&
            object.deleted == deleted &&
            object.hobbies.count == hobbies.count
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return NSString(string: safeId)
    }
}
