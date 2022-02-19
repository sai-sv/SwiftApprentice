//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Sergei Sai on 08.02.2022.
//

import Foundation

class ResultArray: Codable {
    var resultCount = 0
    var results = [SearchResult]()
}

class SearchResult: Codable {
    var kind: String? // !audiobook
    var artistName: String?
    var currency = ""
    var imageSmall = ""
    var imageLarge = ""
    
    // !audiobook
    var trackName: String?
    var trackViewUrl: String?
    var trackPrice: Double?
    
    // audiobook
    var collectionName: String?
    var collectionViewUrl: String?
    var collectionPrice: Double?
    
    // !(software & ebooks)
    var itemGenre: String?
    
    // software & ebooks
    var itemPrice: Double?
    var bookGenre: [String]?
    
    private let typeForKind = [
        "album": NSLocalizedString("Album", comment: "Localized kind: Album"),
        "audiobook": NSLocalizedString("Audio Book", comment: "Localized kind: Audio Book"),
        "book": NSLocalizedString("Book", comment: "Localized kind: Book"),
        "ebook": NSLocalizedString("E-Book", comment: "Localized kind: E-Book"),
        "feature-movie": NSLocalizedString("Movie", comment: "Localized kind: Movie"),
        "music-video": NSLocalizedString("Music Video", comment: "Localized kind: Music Video"),
        "podcast": NSLocalizedString("Podcast", comment: "Localized kind: Podcast"),
        "software": NSLocalizedString("App", comment: "Localized kind: App"),
        "song": NSLocalizedString("Song", comment: "Localized kind: Song"),
        "tv-episode": NSLocalizedString("TV Episode", comment: "Localized kind: TV Episode")
    ]
    
    var type: String {
        let kind =  self.kind ?? "audiobook"
        return typeForKind[kind] ?? kind
    }
    
    var artist: String {
        return artistName ?? ""
    }
    
    var name: String {
        return trackName ?? collectionName ?? ""
    }
    
    var storeUrl: String {
        return trackViewUrl ?? collectionViewUrl ?? ""
    }
    
    var price: Double {
        return trackPrice ?? collectionPrice ?? 0.0
    }
    
    var genre: String {
        if let genre = itemGenre {
            return genre
        } else if let genres = bookGenre {
            return genres.joined(separator: ", ")
        }
        return ""
    }
    
    enum CodingKeys: String, CodingKey {
        case kind, artistName, currency
        case imageSmall = "artworkUrl60"
        case imageLarge = "artworkUrl100"
        case trackName, trackViewUrl, trackPrice
        case collectionName, collectionViewUrl, collectionPrice
        case itemGenre = "primaryGenreName"
        case itemPrice = "price"
        case bookGenre = "genres"
    }
}

extension SearchResult: CustomStringConvertible {
    
    var description: String {
        return "\nResult - Kind: \(kind ?? "None"), Name: \(name), Artist Name: \(artistName ?? "None")"
    }
}

func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
    //sort from A to Z
    return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
}
