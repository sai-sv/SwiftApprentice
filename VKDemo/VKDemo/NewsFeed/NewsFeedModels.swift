//
//  NewsFeedModels.swift
//  VKDemo
//
//  Created by Admin on 22.12.2019.
//  Copyright (c) 2019 sergei. All rights reserved.
//

import UIKit

enum NewsFeed {
    
    enum Model {
        struct Request {
            enum RequestType {
                case getNewsFeed
                case revealPostText(postId: Int)
                case getUsers
                case getNextBatch
            }
        }
        struct Response {
            enum ResponseType {
                case presentNewsFeed(response: NewsFeedResponse, revealedPostIds: [Int])
                case presentUserInfo(response: UserResponse?)
                case presentFooterRefreshControl
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayNewsFeed(viewModel: FeedViewModel)
                case displayUserInfo(viewModel: UserViewModel)
                case displayFooterRefreshControl
            }
        }
    }
}

struct FeedViewModel {
    
    struct CellViewModel: NewsFeedCellViewModel {
        var postId: Int
        var icon: String
        var name: String
        var date: String
        var text: String?
        var likes: String?
        var comments: String?
        var reposts: String?
        var views: String?
        var photoAttachments: [NewsFeedCellPhotoAttachmentViewModel]
        var sizes: NewsFeedCellSizes
    }
    
    struct CellPhotoAttachmentViewModel: NewsFeedCellPhotoAttachmentViewModel {
        var photoURL: String
        var width: Int
        var height: Int
    }
    
    let cells: [CellViewModel]
    let footerTitle: String?
}

struct UserViewModel: TitleViewViewModel {
    var photoUrlString: String?    
}
