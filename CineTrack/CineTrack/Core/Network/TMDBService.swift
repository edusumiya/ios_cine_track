//
//  TMDBService.swift
//  CineTrack
//
//  Created by Eduardo Sumiya on 20/03/26.
//

import Foundation

@MainActor
protocol TMDBServiceProtocol {
    func fetchNowPlaying() async throws -> MediaResponse<Movie>
    func fetchPopularMovies() async throws -> MediaResponse<Movie>
    func fetchTopRated() async throws -> MediaResponse<Movie>
    func fetchMovieDetail(id: Int) async throws -> MovieDetail
    func fetchMovieCredits(id: Int) async throws -> Credits
    func searchMovies(query: String) async throws -> MediaResponse<Movie>
    func fetchPopularTVShows() async throws -> MediaResponse<TVShow>
    func fetchTVShowDetail(id: Int) async throws -> TVShowDetail
    func fetchTVShowCredits(id: Int) async throws -> Credits
}

final class TMDBService {
    
    // MARK: - Singleton
    // Using a shared instance keeps things simple for Phase 1.
    // In a larger app, we'd inject this via initializer (dependency injection).
    static let shared = TMDBService()
    
    private let apiKey = Secrets.tmdbAPIKey
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    private init() {
        self.session = .shared
        
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    // MARK: - Public Methods
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        guard let url = endpoint.url(apiKey: apiKey) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }
}

// MARK: - Fetch Methods
extension TMDBService: TMDBServiceProtocol {
    // MARK: - Movie
    func fetchNowPlaying() async throws -> MediaResponse<Movie> {
        try await request(.nowPlaying)
    }
    
    func fetchPopularMovies() async throws -> MediaResponse<Movie> {
        try await request(.popular)
    }
    
    func fetchTopRated() async throws -> MediaResponse<Movie> {
        try await request(.topRated)
    }
    
    func searchMovies(query: String) async throws -> MediaResponse<Movie> {
            try await request(.searchMovies(query: query))
        }
    
    // MARK: - Movie Detail
    func fetchMovieDetail(id: Int) async throws -> MovieDetail {
        try await request(.movieDetail(id: id))
    }
    
    // MARK: - Movie Credits
    func fetchMovieCredits(id: Int) async throws -> Credits {
        try await request(.movieCredits(id: id))
    }
    
    // MARK: - TV Shows
    func fetchPopularTVShows() async throws -> MediaResponse<TVShow> {
        try await request(.popularTVShows)
    }
    
    // MARK: - TVShow Detail
    func fetchTVShowDetail(id: Int) async throws -> TVShowDetail {
        try await request(.tvShowDetail(id: id))
    }
    
    func fetchTVShowCredits(id: Int) async throws -> Credits {
        try await request(.tvShowCredits(id: id))
    }
}
