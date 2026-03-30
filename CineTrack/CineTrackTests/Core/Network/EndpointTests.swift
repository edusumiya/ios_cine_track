//
//  Endpoint.swift
//  CineTrack
//
//  Created by Eduardo Sumiya on 30/03/26.
//

import Foundation
import Testing
@testable import CineTrack


@Suite("Endpoint")
struct EndpointTests {
    
    @MainActor
    @Test("nowPlaying builds correct URL")
    func nowPlayingURL() {
        let url = Endpoint.nowPlaying.url(apiKey: "testKey")
        
        #expect(url?.path == "/3/movie/now_playing")
        #expect(url?.query?.contains("api_key=testKey&language=en-US") == true)
        #expect(url?.query?.contains("language=en-US") == true)
    }
    
    @MainActor
    @Test("movieDetail builds URL with correct ID")
    func movieDetailURL() {
        let url = Endpoint.movieDetail(id: 42).url(apiKey: "key")
        #expect(url?.path == "/3/movie/42")
    }
    
    @MainActor
    @Test("searchMovies includes query parameter")
    func searchMoviesURL() {
        let url = Endpoint.searchMovies(query: "Inception").url(apiKey: "key")
        #expect(url?.query?.contains("query=Inception") == true)
    }
    
    @MainActor
    @Test("tvShowDetail builds URL with correct ID")
    func tvShowDetailURL() {
        let url = Endpoint.tvShowDetail(id: 99).url(apiKey: "key")
        #expect(url?.path == "/3/tv/99")
    }
}
