//
//  NewsfeedResponse.swift
//  VKDemo
//
//  Created by Admin on 27.12.2019.
//  Copyright © 2019 sergei. All rights reserved.
//

import Foundation

struct NewsFeedWrapper: Decodable {
    let response: NewsFeedResponse
}

struct NewsFeedResponse: Decodable {
    var items: [NewsFeedItem]
    var profiles: [UserProfile]
    var groups: [GroupProfile]
    var nextFrom: String
}

struct NewsFeedItem: Decodable {
    let sourceId: Int
    let postId: Int
    let date: Double
    let text: String?
    
    let comments: CountableItem?
    let likes: CountableItem?
    let reposts: CountableItem?
    let views: CountableItem?
    
    let attachments: [Attachment]?
}

struct CountableItem: Decodable {
    let count: Int
}

protocol ProfileRepresentable {
    var id: Int { get }
    var name: String { get }
    var photo: String { get }
}

struct UserProfile: ProfileRepresentable, Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    
    // optional fields
    let photo100: String
    
    var name: String { return "\(firstName) \(lastName)"}
    var photo: String { return photo100 }
}

struct GroupProfile: ProfileRepresentable, Decodable {
    let id: Int
    let name: String
    let photo100: String
    
    var photo: String { return photo100 }
}

struct Attachment: Decodable {
    let photo: PhotoAttachment?
}

struct PhotoAttachment: Decodable {
    let id: Int
    let albumId: Int
    let ownerId: Int
    let text: String
    let date: Double
    let sizes: [PhotoSize]
    var width: Int { return getPhoto().width }
    var height: Int { return getPhoto().height }
    var url: String { return getPhoto().url }
       
    private func getPhoto() -> PhotoSize {
        
        if let expectedPhotoSize = sizes.first(where: { $0.type == "x"}) {
            return expectedPhotoSize
        } else if let lastPhotoSize = sizes.last {
            return lastPhotoSize
        }
        return PhotoSize(type: "WrongImageType", url: "InvalidURL", width: 0, height: 0)
    }
}

struct PhotoSize: Decodable {
    let type: String
    let url: String
    let width: Int
    let height: Int
}
