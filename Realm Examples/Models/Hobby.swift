//
//  Hobby.swift
//  Realm Examples
//
//  Created by Joseph Quigley on 12/11/17.
//  Copyright © 2017 Joseph Quigley. All rights reserved.
//

import Foundation
import RealmSwift

class Hobby: Object {
    @objc dynamic var name = ""
    var difficulty = RealmOptional<Int>()
}
