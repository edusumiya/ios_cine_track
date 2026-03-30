//
//  SavedMedia.swift
//  CineTrack
//
//  Created by Eduardo Sumiya on 23/03/26.
//

import Foundation
import SwiftData

@Model
final class SavedMedia {
    // MARK: - Stored Properties
    var mediaId: Int
    var title: String
    var posterPath: String?
    var releaseYear: String
    var rating: Double
    var mediaTypeRaw: String   // "movie" or "tvshow"
    var listTypeRaw: String    // "favorite", "watchlist", "watched"
    var savedAt: Date
    
    init(
        mediaId: Int,
        title: String,
        posterPath: String?,
        releaseYear: String,
        rating: Double,
        mediaType: SavedMediaType,
        listType: SavedListType
    ) {
        self.mediaId = mediaId
        self.title = title
        self.posterPath = posterPath
        self.releaseYear = releaseYear
        self.rating = rating
        self.mediaTypeRaw = mediaType.rawValue
        self.listTypeRaw = listType.rawValue
        self.savedAt = Date()
    }
    
    // MARK: - Computed
    var mediaType: SavedMediaType {
        SavedMediaType(rawValue: mediaTypeRaw) ?? .movie
    }
    
    var listType: SavedListType {
        SavedListType(rawValue: listTypeRaw) ?? .favorite
    }
    
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    var formattedRating: String {
        String(format: "%.1f", rating)
    }
}

// MARK: - Enums
enum SavedMediaType: String {
    case movie = "movie"
    case tvShow = "tvshow"
}

enum SavedListType: String, CaseIterable {
    case favorite = "favorite"
    case watchlist = "watchlist"
    case watched = "watched"
    
    var title: String {
        switch self {
        case .favorite:  return "Favorites"
        case .watchlist: return "Watchlist"
        case .watched:   return "Watched"
        }
    }
    
    var icon: String {
        switch self {
        case .favorite:  return "heart.fill"
        case .watchlist: return "bookmark.fill"
        case .watched:   return "checkmark.circle.fill"
        }
    }
}
