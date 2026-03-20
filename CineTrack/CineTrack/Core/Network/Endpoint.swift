//
//  Endpoint.swift
//  CineTrack
//
//  Created by Eduardo Sumiya on 20/03/26.
//

import Foundation

enum Endpoint {
    case nowPlaying
    case popular
    case topRated
    case movieDetail(id: Int)
    case movieCredits(id: Int)
    case searchMovies(query: String)
    case popularTVShows
    case tvShowDetail(id: Int)
    
    // MARK: - Variables
    private var baseURL: String {
        "https://api.themoviedb.org/3"
    }
    
    var path: String {
        switch self {
        case .nowPlaying:               return "/movie/now_playing"
        case .popular:                  return "/movie/popular"
        case .topRated:                 return "/movie/top_rated"
        case .movieDetail(let id):      return "/movie/\(id)"
        case .movieCredits(let id):     return "/movie/\(id)/credits"
        case .searchMovies:             return "/search/movie"
        case .popularTVShows:           return "/tv/popular"
        case .tvShowDetail(let id):     return "/tv/\(id)"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .searchMovies(let query):
            return [URLQueryItem(name: "query", value: query)]
        default:
            return []
        }
    }
    
    // MARK: - Public Methods
    func url(apiKey: String) -> URL? {
        var components = URLComponents(string: baseURL + path)
        var items = queryItems
        
        items.append(URLQueryItem(name: "api_key", value: apiKey))
        items.append(URLQueryItem(name: "language", value: "en-US"))
        components?.queryItems = items
        
        return components?.url
    }
}
