//
//  GalleryCollectionView.swift
//  VKDemo
//
//  Created by Admin on 13.02.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import Foundation
import UIKit

class GalleryCollectionView: UICollectionView {
    
    var model: [NewsFeedCellPhotoAttachmentViewModel] = []
    
    init() {
        let layout = GalleryCollectionViewRowLayout()
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        
        if let rowLayout = collectionViewLayout as? GalleryCollectionViewRowLayout {
            rowLayout.delegate = self
        }
        
        delegate = self
        dataSource = self        
        
        register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseId)
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(model: [NewsFeedCellPhotoAttachmentViewModel]) {
        self.model = model
        contentSize = .zero
        reloadData()
    }
}

extension GalleryCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.reuseId, for: indexPath) as! GalleryCollectionViewCell
        cell.set(url: model[indexPath.row].photoURL)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }
}

// MARK: - GalleryCollectionViewRowLayoutDelegate
extension GalleryCollectionView: GalleryCollectionViewRowLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView, indexPath: IndexPath) -> CGSize {
        let photo = model[indexPath.row]
        return CGSize(width: photo.width, height: photo.height)
    }
}
