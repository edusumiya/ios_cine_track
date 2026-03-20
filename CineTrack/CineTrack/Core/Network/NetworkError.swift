//
//  NetworkError.swift
//  CineTrack
//
//  Created by Eduardo Sumiya on 20/03/26.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decoding(Error)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "invalid URL."
        case .invalidResponse:
            return "invalid Response"
        case .statusCode(let code):
            return "Request failed with status code \(code)"
        case .decoding(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
