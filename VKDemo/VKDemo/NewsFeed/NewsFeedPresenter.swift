//
//  NewsFeedPresenter.swift
//  VKDemo
//
//  Created by Admin on 22.12.2019.
//  Copyright (c) 2019 sergei. All rights reserved.
//

import UIKit

protocol NewsFeedPresentationLogic {
    func presentData(response: NewsFeed.Model.Response.ResponseType)
}

class NewsFeedPresenter: NewsFeedPresentationLogic {
    weak var viewController: NewsFeedDisplayLogic?
    private let cellLayoutCalculator: NewsFeedCellLayoutCalculatorProtocol = NewsFeedCellLayoutCalculator()
    
    private let dateFormatter: DateFormatter = {
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        dt.dateFormat = "d MMM 'в' HH:mm"
        return dt
    }()
    
    func presentData(response: NewsFeed.Model.Response.ResponseType) {
        
        switch response {
        case .presentNewsFeed(let response, let revealedPostIds):
            let cells = response.items.map { (item) in
                
                cellViewModel(item, profiles: response.profiles, groups: response.groups, revealedPostIds: revealedPostIds)
            }            
            let footerTitle = String.localizedStringWithFormat(NSLocalizedString("NewsFeedCellsCount", comment: ""), cells.count)
            print(#function + footerTitle)
            let viewModel = FeedViewModel(cells: cells, footerTitle: footerTitle)
            
            viewController?.displayData(viewModel: .displayNewsFeed(viewModel: viewModel))
            break
            
        case .presentUserInfo(let response):
            let viewModel = UserViewModel(photoUrlString: response?.photo100)
            viewController?.displayData(viewModel: .displayUserInfo(viewModel: viewModel))
            
        case .presentFooterRefreshControl:
            viewController?.displayData(viewModel: .displayFooterRefreshControl)
        }
    }
    
    private func profile(_ sourceId: Int, profiles: [UserProfile], groups: [GroupProfile]) -> ProfileRepresentable? {
        let profiles: [ProfileRepresentable] = sourceId < 0 ? groups : profiles
        let targetSourceId = sourceId < 0 ? -sourceId : sourceId
        return profiles.first { $0.id == targetSourceId }
    }
    
    private func photoViewModel(_ item: NewsFeedItem) -> [FeedViewModel.CellPhotoAttachmentViewModel] {
        guard let attachments = item.attachments else { return [] }
        
        return attachments.compactMap({ (attachment) -> FeedViewModel.CellPhotoAttachmentViewModel? in
            guard let photo = attachment.photo else { return nil }
            return FeedViewModel.CellPhotoAttachmentViewModel(photoURL: photo.url, width: photo.width, height: photo.height)
        })
    }
    
    private func cellViewModel(_ item: NewsFeedItem, profiles: [UserProfile], groups: [GroupProfile], revealedPostIds: [Int]) -> FeedViewModel.CellViewModel {
        
        let postId = item.postId
        
        let profile = self.profile(item.sourceId, profiles: profiles, groups: groups)
        
        let date = Date(timeIntervalSince1970: item.date)
        let dateTitle = dateFormatter.string(from: date)
        
        //let photoAttachmentViewModel = photoViewModel(item)
        let photoAttachmentViewModel = photoViewModel(item)
        
        // is post text revealed by user interaction
        let isPostTextRevealed = revealedPostIds.contains(postId)
        
        let sizes = cellLayoutCalculator.sizes(postText: item.text, postPhotoAttachments: photoAttachmentViewModel, isPostTextRevealed: isPostTextRevealed)
        
        return FeedViewModel.CellViewModel(postId: postId,
                                           icon: profile?.photo ?? "",
                                           name: profile?.name ?? "",
                                           date: dateTitle,
                                           text: item.text,
                                           likes: formattedCounter(item.likes?.count),
                                           comments: formattedCounter(item.comments?.count),
                                           reposts: formattedCounter(item.reposts?.count),
                                           views: formattedCounter(item.views?.count),
                                           photoAttachments: photoAttachmentViewModel,
                                           sizes: sizes)
    }
    
    private func formattedCounter(_ count: Int?) -> String? {
        guard let counter = count, counter > 0 else { return nil }
        var string = String(counter)
        if 4...6 ~= string.count {
            string = String(string.dropLast(3)) + "K"
        } else if string.count > 6 {
            string = String(string.dropLast(6)) + "M"
        }
        return string
    }
}
