//
//  ViewController.swift
//  Realm Examples
//
//  Created by Joseph Quigley on 12/10/17.
//  Copyright © 2017 Joseph Quigley. All rights reserved.
//

import UIKit
import RealmSwift
import IGListKit

class ListViewController: UICollectionViewController {
    private var dataController: ListAdapterDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.isPagingEnabled = true
        collectionView?.alwaysBounceVertical = true
        dataController = ListDataController(collectionView: collectionView, viewController: self)
    }
}

