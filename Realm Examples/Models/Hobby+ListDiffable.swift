//
//  Hobby+ListDiffable.swift
//  Realm Examples
//
//  Created by Joseph Quigley on 12/13/17.
//  Copyright © 2017 Joseph Quigley. All rights reserved.
//

import IGListKit

extension Hobby: ListDiffable {
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Hobby else {
            return false
        }
        return object.name == name &&
            object.difficulty.value == difficulty.value
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return NSString(string: name)
    }
}

