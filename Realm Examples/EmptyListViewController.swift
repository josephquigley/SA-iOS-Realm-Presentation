//
//  EmptyListViewController.swift
//  Realm Examples
//
//  Created by Joseph Quigley on 12/11/17.
//  Copyright © 2017 Joseph Quigley. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift

class EmptyListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        let label = UILabel()
        label.text = "Users? We don't need no stinkin' users."
        label.textColor = .white
        
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        let button = UIButton()
        button.setTitle("Populate Stinkin' Users", for: .normal)
        view.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.top.equalTo(label).offset(50)
            make.centerX.equalToSuperview()
        }
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        
        button.addTarget(self, action: #selector(populate), for: .touchUpInside)
        
    }
    
    @objc private func populate() {
        let realm = try! Realm()
        let num = max(5, Int(arc4random()) % 10)
        
        let firstNames = [
            "Bob",
            "Joe",
            "Ryan",
            "Spock",
            "Malcolm",
            "Kaylee",
            "Jayne",
            "Mike",
            "Eleven",
            "Steve"
        ]
        
        let lastNames = [
            "Reynolds",
            "Cobb",
            "Marley",
            "Hopper",
            "Ives",
            "Hernandez",
            "Washington"
        ]
        
        let hobbies: [Hobby] = [
            "Biking",
            "Netflix Watching",
            "Bitcoin Investing",
            "Gambling",
            "<Redacted>"
        ].map { name in
            let hobby = Hobby()
            hobby.name = name
            
            let difficulty = Int(arc4random()) % 4
            
            //Don't want to reveal difficulty info about <Redacted>
            hobby.difficulty.value = name == "<Redacted>" ? nil : difficulty
            
            return hobby
        }
        
        for _ in 0...num {
            let fnIndex = Int(arc4random()) % (firstNames.count - 1)
            let lnIndex = Int(arc4random()) % (lastNames.count - 1)
            
            let user = User()
            user.firstName = firstNames[fnIndex]
            user.lastName = lastNames[lnIndex]
            
            let hobbyCount = max(2, Int(arc4random()) % (hobbies.count - 1))
            var hobbiesSet = Set<Hobby>()
            
            for _ in 0...hobbyCount {
                hobbiesSet.insert(hobbies[Int(arc4random()) % (hobbies.count - 1)])
            }
            
            for hobby in hobbiesSet {
                user.hobbies.append(hobby)
            }
            
            try! realm.write {
                realm.add(hobbies)
                realm.add(user)
            }
        }
        
    }
}
