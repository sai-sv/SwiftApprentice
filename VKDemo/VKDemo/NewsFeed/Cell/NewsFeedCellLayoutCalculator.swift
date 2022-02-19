//
//  NewsFeedCellLayoutCalculator.swift
//  VKDemo
//
//  Created by Admin on 04.02.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import Foundation
import UIKit

protocol NewsFeedCellLayoutCalculatorProtocol {
    
    func sizes(postText: String?, postPhotoAttachments: [FeedViewModel.CellPhotoAttachmentViewModel], isPostTextRevealed: Bool) -> NewsFeedCellSizes
}

struct CellSizes: NewsFeedCellSizes {
    var textFrame: CGRect
    var moreTextButtonFrame: CGRect
    var photoAttachmentFrame: CGRect
    var bottomViewFrame: CGRect
    var totalHeight: CGFloat
}

final class NewsFeedCellLayoutCalculator: NewsFeedCellLayoutCalculatorProtocol {
    
    private var screenWidth: CGFloat
    
    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }
    
    func sizes(postText: String?, postPhotoAttachments: [FeedViewModel.CellPhotoAttachmentViewModel], isPostTextRevealed: Bool) -> NewsFeedCellSizes {
        
        let cardViewWidth = screenWidth - Constants.cardViewInsets.left - Constants.cardViewInsets.right
        
        var isShowMoreTextButtonHidden = true
        
        // MARK: - post text frame
        var postTextFrame = CGRect(origin: CGPoint(x: Constants.postTextInsets.left, y: Constants.postTextInsets.top), size: CGSize.zero)
        if let text = postText, !text.isEmpty {
            let width = cardViewWidth - Constants.postTextInsets.left - Constants.postTextInsets.right
            var height = text.height(width: width, font: Constants.postTextFont)
            
            // MARK: - show more text button flag
            let postTextVisibleHeightThreshold = Constants.postTextFont.lineHeight * Constants.minifiedPostLimitLines
            if !isPostTextRevealed && (height > postTextVisibleHeightThreshold) {
                height = Constants.postTextFont.lineHeight * Constants.minifiedPostLines
                isShowMoreTextButtonHidden = false
            }
            
            postTextFrame.size = CGSize(width: width, height: height)
        }
        
        // MARK: - more button frame
        let showMoreTextButtonSize = isShowMoreTextButtonHidden ? CGSize.zero : Constants.showMoreTextButtonSize
        let showMoreButtonFrame = CGRect(origin: CGPoint(x: Constants.showMoreButtonInsets.left, y: postTextFrame.maxY), size: showMoreTextButtonSize)
                
        // MARK: - post photo attachment frame
        let photoAttachmentTop = postTextFrame.size == CGSize.zero ? Constants.postTextInsets.top : showMoreButtonFrame.maxY + Constants.postTextInsets.bottom
        var postPhotoAttachmentFrame = CGRect(origin: CGPoint(x: 0, y: photoAttachmentTop), size: CGSize.zero)
        if let photoAttachment = postPhotoAttachments.first {
            if postPhotoAttachments.count == 1 {
                let ratio = CGFloat(CGFloat(photoAttachment.height) / CGFloat(photoAttachment.width))
                let height = CGFloat(cardViewWidth) * ratio
                postPhotoAttachmentFrame.size = CGSize(width: cardViewWidth, height: height)
            } else if postPhotoAttachments.count > 1 {
                let photosSizes: [CGSize] = postPhotoAttachments.map { CGSize(width: $0.width, height: $0.height) }
                let rowHeight = GalleryCollectionViewRowLayout.rowHeight(superViewWidth: cardViewWidth, photosSizes: photosSizes)
                let height = rowHeight! * CGFloat(GalleryCollectionViewRowLayout.numbersOfRows)
                postPhotoAttachmentFrame.size = CGSize(width: cardViewWidth, height: height)
            }
        }
        
        // MARK: - bottom view frame
        let bottomViewTop = max(postTextFrame.maxY, postPhotoAttachmentFrame.maxY)
        let bottomViewFrame = CGRect(origin: CGPoint(x: 0, y: bottomViewTop), size: CGSize(width: cardViewWidth, height: Constants.bottomViewHeight))
        
        // MARK: - total height
        let totalHeight: CGFloat =  bottomViewFrame.maxY + Constants.cardViewInsets.bottom
        
        return CellSizes(textFrame: postTextFrame,
                         moreTextButtonFrame: showMoreButtonFrame,
                         photoAttachmentFrame: postPhotoAttachmentFrame,
                         bottomViewFrame: bottomViewFrame,
                         totalHeight: totalHeight)
    }
}
