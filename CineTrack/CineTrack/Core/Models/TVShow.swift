//
//  TVShow.swift
//  CineTrack
//
//  Created by Eduardo Sumiya on 20/03/26.
//

import Foundation

// MARK: - TV Show
struct TVShow: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let firstAirDate: String?
    let voteAverage: Double
    let popularity: Double
 
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
 
    var firstAirYear: String {
        firstAirDate?.prefix(4).description ?? "N/A"
    }
 
    var formattedRating: String {
        String(format: "%.1f", voteAverage)
    }
}

// MARK: - TV Show Detail
struct TVShowDetail: Decodable, Identifiable {
    let id: Int
    let name: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let firstAirDate: String?
    let voteAverage: Double
    let numberOfSeasons: Int?
    let numberOfEpisodes: Int?
    let episodeRunTime: [Int]
    let genres: [Genre]
    let tagline: String?
    let status: String?

    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }

    var backdropURL: URL? {
        guard let path = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w780\(path)")
    }

    var firstAirYear: String {
        firstAirDate?.prefix(4).description ?? "N/A"
    }

    var formattedRating: String {
        String(format: "%.1f", voteAverage)
    }

    // TV Shows retornam um array de durações por episódio
    var formattedRuntime: String {
        guard let runtime = episodeRunTime.first else { return "N/A" }
        return "\(runtime)m / ep"
    }

    var formattedSeasons: String {
        guard let seasons = numberOfSeasons else { return "N/A" }
        return seasons == 1 ? "1 Season" : "\(seasons) Seasons"
    }
}
