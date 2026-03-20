//
//  TMDBService.swift
//  CineTrack
//
//  Created by Eduardo Sumiya on 20/03/26.
//

import Foundation

final class TMBService {
    
    // MARK: - Singleton
    // Using a shared instance keeps things simple for Phase 1.
    // In a larger app, we'd inject this via initializer (dependency injection).
    static let shared = TMBService()
    
    private let apiKey = "7137bc4ac21ea37a37259343a01f97ec"
    
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
extension TMBService {
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
    
    // MARK: - MovieDetail
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
}
