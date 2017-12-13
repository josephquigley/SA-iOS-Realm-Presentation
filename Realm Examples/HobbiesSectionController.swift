//
//  HobbiesSectionController.swift
//  Realm Examples
//
//  Created by Joseph Quigley on 12/13/17.
//  Copyright © 2017 Joseph Quigley. All rights reserved.
//

import IGListKit
import RealmSwift

class HobbiesSectionController: ListSectionController, UIViewControllerTransitioningDelegate {
    private var hobby: Hobby?
    var filterDataAction: ((NSPredicate?)->())?
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: min(collectionContext!.containerSize.width, 300), height: min(collectionContext!.containerSize.height, 45))
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCellFromStoryboard(withIdentifier: "Hobby", for: self, at: index)
        
        if let cell = cell as? HobbyCell, let model = hobby {
            var difficulty = "<Redacted>"
            if let difficultyValue = model.difficulty.value {
                difficulty = "\(difficultyValue)"
            }
            
            cell.hobbyLabel.text = "\(model.name) (Difficulty: \(difficulty))"
        }
        
        return cell
    }
    
    
    override func numberOfItems() -> Int {
        return hobby == nil ? 0 : 1
    }
    
    override func didUpdate(to object: Any) {
        hobby = object as? Hobby
    }
    
    override func didSelectItem(at index: Int) {
        super.didSelectItem(at: index)
        collectionContext?.deselectItem(at: index, sectionController: self, animated: false)
        
        guard let hobby = hobby else {
            return
        }
        
        //Be sure to add the .@count > 0 to return a bool for the predicate to resolve to,
        //otherwise runtime crashes will occur 😬
        filterDataAction?(NSPredicate(format: "SUBQUERY(hobbies, $hobby, $hobby.name == '\(hobby.name)') .@count > 0"))
    }
}
