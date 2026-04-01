//
//  MockTMDBService.swift
//  CineTrack
//
//  Created by Eduardo Sumiya on 30/03/26.
//

import Foundation
@testable import CineTrack

@MainActor
final class MockTMDBService: TMDBServiceProtocol {
    //Mock controls
    var nowPlayingResult: Result<MediaResponse<Movie>, Error> = .success(
        MediaResponse(results: [], totalPages: 0, totalResults: 0)
    )
    var popularMoviesResult: Result<MediaResponse<Movie>, Error> = .success(
        MediaResponse(results: [], totalPages: 0, totalResults: 0)
    )
    var topRatedResult: Result<MediaResponse<Movie>, Error> = .success(
        MediaResponse(results: [], totalPages: 0, totalResults: 0)
    )
    var movieDetailResult: Result<MovieDetail, Error> = .success(
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
        )
    )
    var movieCreditsResult: Result<Credits, Error> = .success(Credits(cast: [], crew: []))
    var searchResult: Result<MediaResponse<Movie>, Error> = .success(
        MediaResponse(results: [], totalPages: 0, totalResults: 0)
    )
    var popularTVShowsResult: Result<MediaResponse<TVShow>, Error> = .success(
        MediaResponse(results: [], totalPages: 0, totalResults: 0)
    )
    var tvShowDetailResult: Result<TVShowDetail, Error> = .success(
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
    )
    var tvShowCreditsResult: Result<Credits, Error> = .success(Credits(cast: [], crew: []))
    
    // Counters
    var fetchNowPlayingCallCount = 0
    var fetchPopularMoviesCallCount = 0
    var searchMoviesCallCount = 0
    var lastSearchQuery: String?
    
    // MARK: - TMDBServiceProtocol
    func fetchNowPlaying() async throws -> CineTrack.MediaResponse<CineTrack.Movie> {
        fetchNowPlayingCallCount += 1
        
        return try self.nowPlayingResult.get()
    }
    
    func fetchPopularMovies() async throws -> CineTrack.MediaResponse<CineTrack.Movie> {
        fetchPopularMoviesCallCount += 1
        
        return try self.popularMoviesResult.get()
    }
    
    func fetchTopRated() async throws -> CineTrack.MediaResponse<CineTrack.Movie> {
        try topRatedResult.get()
    }
    
    func fetchMovieDetail(id: Int) async throws -> CineTrack.MovieDetail {
        try movieDetailResult.get()
    }
    
    func fetchMovieCredits(id: Int) async throws -> CineTrack.Credits {
        try movieCreditsResult.get()
    }
    
    func searchMovies(query: String) async throws -> CineTrack.MediaResponse<CineTrack.Movie> {
        searchMoviesCallCount += 1
        lastSearchQuery = query
        
        return try self.searchResult.get()
    }
    
    func fetchPopularTVShows() async throws -> CineTrack.MediaResponse<CineTrack.TVShow> {
        try popularTVShowsResult.get()
    }
    
    func fetchTVShowDetail(id: Int) async throws -> CineTrack.TVShowDetail {
        try tvShowDetailResult.get()
    }
    
    func fetchTVShowCredits(id: Int) async throws -> CineTrack.Credits {
        try tvShowCreditsResult.get()
    }
}
