//
//  MockData.swift
//  CineTrack
//
//  Created by Eduardo Sumiya on 30/03/26.
//

import Foundation
@testable import CineTrack

@MainActor
extension MediaResponse where T == Movie {
    static var empty: Self {
        MediaResponse(results: [], totalPages: 0, totalResults: 0)
    }
    
    static func with(_ movies: [Movie]) -> Self {
        MediaResponse(results: movies, totalPages: 1, totalResults: movies.count)
    }
}

@MainActor
extension MediaResponse where T == TVShow {
    static var empty: Self {
        MediaResponse(results: [], totalPages: 0, totalResults: 0)
    }
}

@MainActor
extension Credits {
    static var empty: Self {
        Credits(cast: [], crew: [])
    }

    static var withDirector: Self {
        Credits(
            cast: [
                CastMember(id: 1, name: "Actor One", character: "Hero", profilePath: nil),
                CastMember(id: 2, name: "Actor Two", character: "Villain", profilePath: nil)
            ],
            crew: [
                CrewMember(id: 10, name: "Jane Doe", job: "Director", department: "Directing")
            ]
        )
    }
}

@MainActor
extension Movie {
    static func mock(id: Int = 1, title: String = "Mock Movie") -> Movie {
        Movie(
            id: id,
            title: title,
            overview: "A test movie overview.",
            posterPath: "/mock.jpg",
            backdropPath: nil,
            releaseDate: "2024-01-01",
            voteAverage: 7.5,
            voteCount: 1000,
            popularity: 100.0
        )
    }
}

@MainActor
extension MovieDetail {
    static var mock: MovieDetail {
        MovieDetail(
            id: 1,
            title: "Mock Movie Detail",
            overview: "Detailed overview.",
            posterPath: "/mock.jpg",
            backdropPath: nil,
            releaseDate: "2024-01-01",
            voteAverage: 8.0,
            runtime: 120,
            genres: [Genre(id: 28, name: "Action")],
            tagline: "A mock tagline"
//            status: "Released"
        )
    }
}

@MainActor
extension TVShow {
    static func mock(id: Int = 1, name: String = "Mock Show") -> TVShow {
        TVShow(
            id: id,
            name: name,
            overview: "A test show overview.",
            posterPath: "/mockshow.jpg",
            backdropPath: nil,
            firstAirDate: "2023-09-01",
            voteAverage: 8.2,
            popularity: 200.0
        )
    }
}

@MainActor
extension TVShowDetail {
    static var mock: TVShowDetail {
        TVShowDetail(
            id: 1,
            name: "Mock Show Detail",
            overview: "Detailed show overview.",
            posterPath: "/mockshow.jpg",
            backdropPath: nil,
            firstAirDate: "2023-09-01",
            voteAverage: 8.5,
            numberOfSeasons: 3,
            numberOfEpisodes: 30,
            episodeRunTime: [45],
            genres: [Genre(id: 18, name: "Drama")],
            tagline: "A show tagline",
            status: "Returning Series"
        )
    }
}
