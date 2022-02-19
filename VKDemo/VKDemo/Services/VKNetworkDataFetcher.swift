//
//  VKNetworkDataFetcher.swift
//  VKDemo
//
//  Created by Admin on 27.12.2019.
//  Copyright © 2019 sergei. All rights reserved.
//

import Foundation

protocol VKDataFetcher {
    func getNewsFeed(startFrom: String?, response: @escaping (NewsFeedResponse?) -> Void)
    func getUsers(response: @escaping (UserResponse?) -> Void)
}

struct VKURLConstants {
    static let scheme = "https"
    static let host = "api.vk.com"
    static let apiVersion = "5.103"
    
    static let getNewsfeedMethod = "/method/newsfeed.get"
    static let getUsersMethod = "/method/users.get"
}

class VKNetworkDataFetcher: NetworkDataFetcher, VKDataFetcher {
    
    private let accessToken: String?
    private let userId: String?
    private var accessTokenItem: URLQueryItem {
        return URLQueryItem(name: "access_token", value: accessToken)
    }
    private var userIdItem: URLQueryItem {
        return URLQueryItem(name: "user_ids", value: userId)
    }
    private var versionItem: URLQueryItem {
        return URLQueryItem(name: "v", value: VKURLConstants.apiVersion)
    }
    
    init() {
        accessToken = AppDelegate.shared().authService?.accessToken
        userId = AppDelegate.shared().authService?.userId
        super.init()
    }
    
    // MARK: - VKDataFetcher
    func getNewsFeed(startFrom: String?, response: @escaping (NewsFeedResponse?) -> Void) {
     
        var components = URLComponents()
        components.scheme = VKURLConstants.scheme
        components.host = VKURLConstants.host
        components.path = VKURLConstants.getNewsfeedMethod
        let filters = URLQueryItem(name: "filters", value: "post, photo")
        let startFromItem = URLQueryItem(name: "start_from", value: startFrom)
        components.queryItems = [ filters, startFromItem, accessTokenItem, versionItem]    
        
        let request = URLRequest(url: components.url!)
        
        self.fetchData(request: request) { (result: Result<NewsFeedWrapper, Error>) in
            
            switch result {
            case .success(let data):
                response(data.response)
                //print(data.response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getUsers(response: @escaping (UserResponse?) -> Void) {
        
        var components = URLComponents()
        components.scheme = VKURLConstants.scheme
        components.host = VKURLConstants.host
        components.path = VKURLConstants.getUsersMethod
        let fields = URLQueryItem(name: "fields", value: "photo_100")
        components.queryItems = [userIdItem, fields, accessTokenItem, versionItem]
        
        let request = URLRequest(url: components.url!)
        
        self.fetchData(request: request) { (result: Result<UsersWrapper, Error>) in
            switch result {
            case .success(let data):
                response(data.response.first)
//                print(data.response)
            case .failure(let error):
                print("Error")
                print(error)
            }
        }
    }
}
