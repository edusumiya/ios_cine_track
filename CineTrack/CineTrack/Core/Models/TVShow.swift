//
//  TVShow.swift
//  CineTrack
//
//  Created by Eduardo Sumiya on 20/03/26.
//

import Foundation

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
