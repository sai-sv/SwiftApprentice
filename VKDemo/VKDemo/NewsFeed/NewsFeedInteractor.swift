//
//  NewsFeedInteractor.swift
//  VKDemo
//
//  Created by Admin on 22.12.2019.
//  Copyright (c) 2019 sergei. All rights reserved.
//

import UIKit

protocol NewsFeedBusinessLogic {
    func makeRequest(request: NewsFeed.Model.Request.RequestType)
}

class NewsFeedInteractor: NewsFeedBusinessLogic {
    
    var presenter: NewsFeedPresentationLogic?
    var service: NewsFeedService?
    
    func makeRequest(request: NewsFeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsFeedService()
        }
        
        switch request {
        case .getNewsFeed:
            service?.getNewsFeed { [weak self] (response, postsIds) in
                self?.presenter?.presentData(response: .presentNewsFeed(response: response, revealedPostIds: postsIds))
            }
            
        case .revealPostText(let postId):
            service?.revealedPostIds(postId) { [weak self] (response, postsIds) in
                self?.presenter?.presentData(response: .presentNewsFeed(response: response, revealedPostIds: postsIds))
            }
            
        case .getUsers:
            service?.getUsers { [weak self] (response) in
                self?.presenter?.presentData(response: .presentUserInfo(response: response))
            }
            
        case .getNextBatch:
            service?.getNextBatch { [weak self] (response, revealedPostsIds) in
                self?.presenter?.presentData(response: .presentNewsFeed(response: response, revealedPostIds: revealedPostsIds))
            }
            presenter?.presentData(response: .presentFooterRefreshControl)
        }
    }
}
