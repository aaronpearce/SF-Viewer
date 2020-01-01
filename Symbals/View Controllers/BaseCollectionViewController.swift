//
//  BaseCollectionViewController.swift
//  HomeCam2
//
//  Created by Aaron Pearce on 14/06/19.
//  Copyright © 2019 Sunya. All rights reserved.
//

import UIKit

class BaseCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let padding: CGFloat = 16
    
    lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).usingAutoLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
    #if os(iOS)
        collectionView.backgroundColor = .systemBackground
    #endif
        return collectionView
    }()
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInsetReference = .fromSafeArea
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        return layout
    }()
    
    var collectionViewDisplayWidth: CGFloat {
        return collectionView.bounds.width - layout.sectionInset.left - layout.sectionInset.right
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate(collectionView.constraintsToFit(view: view))
        
        #if os(iOS)
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        #else
        
        #endif
    }
    
    func registerCells() {
        fatalError("Subclass should implement this method to register its cells")
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        fatalError("Subclass should implement this method")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fatalError("Subclass should implement this method")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("Subclass should implement this method")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 64
        return CGSize(width: collectionViewDisplayWidth, height: height)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
}
