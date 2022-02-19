//
//  NewsFeedCellProtocol.swift
//  VKDemo
//
//  Created by Admin on 13.02.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import Foundation
import UIKit

protocol NewsFeedCellViewModel {
    var icon: String { get }
    var name: String { get }
    var date: String { get }
    var text: String? { get }
    var likes: String? { get }
    var comments: String? { get }
    var reposts: String? { get }
    var views: String? { get }
    var photoAttachments: [NewsFeedCellPhotoAttachmentViewModel] { get }
    var sizes: NewsFeedCellSizes { get }
}

protocol NewsFeedCellPhotoAttachmentViewModel {
    var photoURL: String { get }
    var width: Int { get }
    var height: Int { get }
}

protocol NewsFeedCellSizes {
    var textFrame: CGRect { get }
    var moreTextButtonFrame: CGRect { get }
    var photoAttachmentFrame: CGRect { get }
    var bottomViewFrame: CGRect { get }
    var totalHeight: CGFloat { get }
}

protocol NewsFeedCodeCellDelegate: class {
    func revealPost(for cell: NewsFeedCodeCell)
}
