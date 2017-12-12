//
//  UserEditViewController.swift
//  Realm Examples
//
//  Created by Joseph Quigley on 12/11/17.
//  Copyright © 2017 Joseph Quigley. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift

class UserEditViewController: UIViewController {
    var user: User? {
        didSet {
            guard let user = user else {
                return
            }
            nameField.text = "\(user.firstName) \(user.lastName)"
        }
    }
    
    private var nameField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.addTarget(self, action: #selector(updateName), for: .valueChanged)
        view.backgroundColor = .gray
        view.addSubview(nameField)
        nameField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(50)
            make.height.equalTo(50)
            make.width.equalTo(250)
        }
        
        nameField.layer.borderWidth = 1
        
        let saveButton = UIButton()
        view.addSubview(saveButton)
        
        let cancelButton = UIButton()
        view.addSubview(cancelButton)
        
        let alignmentView = UIView()
        alignmentView.backgroundColor = .clear
        
        view.addSubview(alignmentView)
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp.bottom)
            make.right.equalTo(alignmentView).offset(5)
        }
        
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp.bottom)
            make.left.equalTo(alignmentView).offset(5)
        }
        
        alignmentView.snp.makeConstraints { make in
            make.centerX.equalTo(nameField)
            make.height.width.equalTo(0)
        }
        
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        
    }
    
    
    @objc private func updateName() {
        guard let user = user else {
            return
        }
        //Create a detached model based off of the saved model to avoid realm write transactions
        let editedUser = User(value: user as Any)
        
        guard let names = nameField.text?.split(separator: " "), names.count >= 2 else {
            return
        }
        
        editedUser.firstName = String(describing: names.first ?? "")
        editedUser.lastName = String(describing: names.last ?? "")
        
        self.user = editedUser
    }
    
    @objc private func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func save() {
        updateName() //To be safe in case the keyboard wasn't dismissed
        dismiss(animated: true, completion: {[unowned self] in
            guard let user = self.user else {
                return
            }
            let realm = try! Realm()
            try? realm.write {
                realm.add(user, update: true)
            }
        })
    }
}
