//
//  UsersSectionController.swift
//  Realm Examples
//
//  Created by Joseph Quigley on 12/11/17.
//  Copyright © 2017 Joseph Quigley. All rights reserved.
//

import IGListKit
import RealmSwift

class UsersSectionController: ListSectionController, UIViewControllerTransitioningDelegate {
    private var user: User?
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: min(collectionContext!.containerSize.width, 300), height: min(collectionContext!.containerSize.height, 100))
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCellFromStoryboard(withIdentifier: "User", for: self, at: index)
        
        if let cell = cell as? UserCell, let model = user {
            cell.nameLabel.text = "\(model.firstName) \(model.lastName)"
            var hobbiesString = model.hobbies.reduce("", {
                "\($0) \($1.name),"
            })
            
            if hobbiesString.count > 0 {
                hobbiesString.removeLast()
            }
            cell.hobbiesLabel.text = hobbiesString
        }
        
        return cell
    }
    
    
    override func numberOfItems() -> Int {
        return user == nil ? 0 : 1
    }
    
    override func didUpdate(to object: Any) {
        user = object as? User
    }
    
    override func didSelectItem(at index: Int) {
        collectionContext?.deselectItem(at: index, sectionController: self, animated: false)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        let editAction = UIAlertAction(title: "Edit", style: .default) {[unowned self] action in
            let editVC = UserEditViewController()
            editVC.user = self.user
            self.viewController?.present(editVC, animated: true, completion: nil)
        }
        alertController.addAction(editAction)
        
        let destroyAction = UIAlertAction(title: "Delete", style: .destructive) {[unowned self] action in
            guard let user = self.user else {
                return
            }
            let realm = try! Realm()
            try! realm.write {
                realm.delete(user)
            }
        }
        alertController.addAction(destroyAction)
        viewController?.present(alertController, animated: true, completion: nil)
    }
}

