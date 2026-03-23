//
//  MediaType.swift
//  CineTrack
//
//  Created by Eduardo Sumiya on 23/03/26.
//

enum MediaType {
    case movie(id: Int)
    case tvShow(id: Int)
    
    var id: Int {
        switch self {
        case .movie(let id): return id
        case .tvShow(let id): return id
        }
    }
}
