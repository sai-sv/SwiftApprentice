//
//  NewsFeedCellConstants.swift
//  VKDemo
//
//  Created by Admin on 10.02.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let cardViewInsets = UIEdgeInsets(top: 0, left: 8, bottom: 12, right: 8)
    
    static let topViewHeight: CGFloat = 36
    
    static let postTextInsets = UIEdgeInsets(top: 8 + topViewHeight + 8, left: 8, bottom: 8, right: 8)
    static let postTextFont = UIFont.systemFont(ofSize: 15)
    
    static let bottomViewHeight: CGFloat = 44
    static let bottomViewSubviewWidth: CGFloat = 80
    static let bottomViewSubviewIconSize: CGFloat = 24
    
    static let showMoreButtonInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    static let showMoreTextButtonSize: CGSize = CGSize(width: 165, height: 30)
    static let minifiedPostLimitLines: CGFloat = 8
    static let minifiedPostLines: CGFloat = 8
    
}
