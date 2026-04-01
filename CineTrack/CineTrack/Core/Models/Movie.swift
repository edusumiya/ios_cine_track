//
//  Movie.swift
//  CineTrack
//
//  Created by Eduardo Sumiya on 20/03/26.
//

import Foundation

// MARK: - Movie
struct Movie: Decodable, Identifiable, Hashable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    
    // MARK: - Properties
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    var backdropURL: URL? {
        guard let path = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w780\(path)")
    }
    
    var releaseYear: String {
        releaseDate?.prefix(4).description ?? "N/A"
    }
    
    var formattedRating: String {
        String(format: "%.1f", voteAverage)
    }
}

// MARK: - MovieDetail
struct MovieDetail: Decodable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let runtime: Int?
    let genres: [Genre]
    let tagline: String?
    
    var posterURL: URL? {
            guard let path = posterPath else { return nil }
            return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
        }
     
        var backdropURL: URL? {
            guard let path = backdropPath else { return nil }
            return URL(string: "https://image.tmdb.org/t/p/w780\(path)")
        }
     
        var releaseYear: String {
            releaseDate?.prefix(4).description ?? "N/A"
        }
     
        var formattedRating: String {
            String(format: "%.1f", voteAverage)
        }
     
        var formattedRuntime: String {
            guard let runtime else { return "N/A" }
            let hours = runtime / 60
            let minutes = runtime % 60
            return hours > 0 ? "\(hours)h \(minutes)m" : "\(minutes)m"
        }
}

// MARK: - Genre
struct Genre: Decodable, Identifiable {
    let id: Int
    let name: String
}
 
// MARK: - Credits
struct Credits: Decodable {
    let cast: [CastMember]
    let crew: [CrewMember]
 
    var director: CrewMember? {
        crew.first { $0.job == "Director" }
    }
 
    var topCast: [CastMember] {
        Array(cast.prefix(10))
    }
}
 
// MARK: - CastMember
struct CastMember: Decodable, Identifiable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?
 
    var profileURL: URL? {
        guard let path = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
    }
}
 
// MARK: - CrewMember
struct CrewMember: Decodable, Identifiable {
    let id: Int
    let name: String
    let job: String
    let department: String
}
