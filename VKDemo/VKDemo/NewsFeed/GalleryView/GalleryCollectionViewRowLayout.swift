//
//  GalleryCollectionViewRowLayout.swift
//  VKDemo
//
//  Created by Admin on 14.02.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import Foundation
import UIKit

protocol GalleryCollectionViewRowLayoutDelegate: class {
    
    func collectionView(collectionView: UICollectionView, indexPath: IndexPath) -> CGSize
}

class GalleryCollectionViewRowLayout: UICollectionViewLayout {
    
    weak var delegate: GalleryCollectionViewRowLayoutDelegate?
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    static let numbersOfRows: Int = 1
    fileprivate let cellPadding: CGFloat = 8
    
    fileprivate var contentWidth: CGFloat = 0
    fileprivate var contentHeight: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let inset = collectionView.contentInset
        return collectionView.bounds.height - (inset.left + inset.right)
    }
    
    override func prepare() {
        // reset
        cache = []
        contentWidth = 0
        
        guard let collectionView = collectionView else { return }
        
        // photos sizes
        var photosSizes = [CGSize]()
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        for item in 0..<itemsCount {
            let indexPath = IndexPath(item: item, section: 0)
            guard let photoSize = delegate?.collectionView(collectionView: collectionView, indexPath: indexPath) else { return }
            
            photosSizes.append(photoSize)
        }
        
        // photos ratios
        let photosRatios = photosSizes.map { $0.height / $0.width }
        
        // calculated row height
        guard let photoHeight = GalleryCollectionViewRowLayout.rowHeight(superViewWidth: collectionView.frame.width, photosSizes: photosSizes) else {
            return
        }
        
        // y offset
        var yOffset = [CGFloat]()
        for value in 0..<GalleryCollectionViewRowLayout.numbersOfRows {
            yOffset.append(photoHeight * CGFloat(value))
        }
        
        // x offset
        var xOffset = [CGFloat].init(repeating: 0, count: GalleryCollectionViewRowLayout.numbersOfRows)
        
        // for each item
        var row = 0
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
           let indexPath = IndexPath(item: item, section: 0)
            
           let photoWidth = photoHeight / photosRatios[item]
            
            // frame
            let photoFrame = CGRect(x: xOffset[row], y: yOffset[row], width: photoWidth, height: photoHeight)
            let insetFrame = photoFrame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // attributes
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribute.frame = insetFrame
            cache.append(attribute)
            
            // x offset
            xOffset[row] += photoWidth
            
            // content width
            contentWidth = max(contentWidth, photoFrame.maxX)
            
            // change row
            row = row < (GalleryCollectionViewRowLayout.numbersOfRows - 1) ? row + 1 : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        for attribute in cache {
            if attribute.frame.intersects(rect) {
                visibleLayoutAttributes.append(attribute)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.row]
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    static func rowHeight(superViewWidth: CGFloat, photosSizes: [CGSize]) -> CGFloat? {
        let photoWithMinSize = photosSizes.min{ (first, second) -> Bool in
            (first.height / first.width) < (second.height / second.width)
        }
        guard let photo = photoWithMinSize else { return nil }
        
        let difference = superViewWidth / photo.width
        return difference * photo.height
    }
}
