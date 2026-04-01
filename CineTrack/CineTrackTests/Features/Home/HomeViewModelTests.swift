//
//  Untitled.swift
//  CineTrack
//
//  Created by Eduardo Sumiya on 30/03/26.
//

import Testing
@testable import CineTrack

@Suite("HomeViewModel")
struct HomeViewModelTests {
    // MARK: - loadContent
    @Test("loads all sections successfully")
    @MainActor
    func loadContent_success() async throws {
        let service = MockTMDBService()
        service.nowPlayingResult = .success(.with([.mock(id: 1, title: "Now Playing")]))
        service.popularMoviesResult = .success(.with([.mock(id: 2, title: "Popular")]))
        service.topRatedResult = .success(.with([.mock(id: 3, title: "Top Rated")]))
        service.popularTVShowsResult = .success(MediaResponse(results: [.mock()], totalPages: 1, totalResults: 1))
        
        let viewModel = HomeViewModel(service: service)
        await viewModel.loadContent()
        
        #expect(viewModel.nowPlayingMovies.count == 1)
        #expect(viewModel.popularMovies.first?.title == "Popular")
        #expect(viewModel.topRatedMovies.count == 1)
        #expect(viewModel.popularTVShows.count == 1)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
    }
    
    @MainActor
    @Test("sets errorMessage when nowPlaying fails")
    func loadContent_nowPlayingFailure() async throws {
        let service = MockTMDBService()
        service.nowPlayingResult = .failure(NetworkError.statusCode(500))
        
        let viewModel = HomeViewModel(service: service)
        await viewModel.loadContent()
        
        #expect(viewModel.nowPlayingMovies.isEmpty)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.isLoading == false)
    }
    
    @MainActor
    @Test("other sections succeed even when one fails")
    func loadContent_partialFailure() async throws {
        let service = MockTMDBService()
        service.nowPlayingResult = .failure(NetworkError.statusCode(500))
        service.popularMoviesResult = .success(.with([.mock()]))
        
        let viewModel = HomeViewModel(service: service)
        await viewModel.loadContent()
        
        #expect(viewModel.nowPlayingMovies.isEmpty)
        #expect(viewModel.popularMovies.count == 1)
    }
    
    @MainActor
    @Test("isLoading is false after load completes")
    func loadContent_resetsLoadingState() async {
        let viewModel = HomeViewModel(service: MockTMDBService())
        await viewModel.loadContent()
        #expect(viewModel.isLoading == false)
    }
}
