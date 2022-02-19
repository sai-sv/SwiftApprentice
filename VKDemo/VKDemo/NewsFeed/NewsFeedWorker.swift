//
//  NewsFeedWorker.swift
//  VKDemo
//
//  Created by Admin on 22.12.2019.
//  Copyright (c) 2019 sergei. All rights reserved.
//

import UIKit

class NewsFeedService {
    
    private let dataFetcher: VKDataFetcher = VKNetworkDataFetcher()
    
    private var response: NewsFeedResponse?
    private var revealedPostIds = Array<Int>()
    
    func getNewsFeed(completion: @escaping (NewsFeedResponse, [Int]) -> Void) {
        dataFetcher.getNewsFeed(startFrom: nil) { [weak self] (response) in
            self?.response = response
            
            guard let response = self?.response else { return }
            completion(response, self!.revealedPostIds)
        }
    }
    
    func revealedPostIds(_ postId: Int, completion: @escaping (NewsFeedResponse, [Int]) -> Void) {
        guard let response = self.response else { return }
        revealedPostIds.append(postId)
        completion(response, revealedPostIds)
    }
    
    func getUsers(completion: @escaping (UserResponse?) -> Void) {
        dataFetcher.getUsers { (response) in
            completion(response)
        }
    }
    
    func getNextBatch(completion: @escaping (NewsFeedResponse, [Int]) -> Void) {
        let nextFrom = self.response?.nextFrom
        dataFetcher.getNewsFeed(startFrom: nextFrom) { [weak self] (response) in
            guard let response = response else { return }
            
            if var prevResponse = self?.response {
                
                prevResponse.items.append(contentsOf: response.items)
                prevResponse.nextFrom = response.nextFrom
                
                var groups = response.groups
                let oldGroups = prevResponse.groups.filter { (oldProfile) -> Bool in
                    !groups.contains { (newProfile) -> Bool in
                        newProfile.id == oldProfile.id
                    }
                }
                groups.append(contentsOf: oldGroups)
                prevResponse.groups = groups
                
                var profiles = response.profiles
                let oldProfiles = prevResponse.profiles.filter { (oldProfile) -> Bool in
                    !profiles.contains { (newProfile) -> Bool in
                        newProfile.id == oldProfile.id
                    }
                }
                profiles.append(contentsOf: oldProfiles)
                prevResponse.profiles = profiles
                
                self?.response = prevResponse
                
            } else {
                self?.response = response
            }
            
            guard let finalResponse = self?.response else { return }
            completion(finalResponse, self!.revealedPostIds)
        }
    }
}
