//
//  MediaResponse.swift
//  CineTrack
//
//  Created by Eduardo Sumiya on 20/03/26.
//

struct MediaResponse<T: Decodable & Identifiable>: Decodable {
    let results: [T]
    let totalPages: Int
    let totalResults: Int
}
