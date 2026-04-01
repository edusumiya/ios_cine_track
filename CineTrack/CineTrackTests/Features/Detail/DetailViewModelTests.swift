//
//  DetailViewModelTests.swift
//  CineTrack
//
//  Created by Eduardo Sumiya on 30/03/26.
//

import Testing
@testable import CineTrack

@Suite("DetailViewModel")
struct DetailViewModelTests {
    
    @MainActor
    @Test("loads movie detail successfully")
    func loadViewModelDetail_success() async {
        let service = MockTMDBService()
        service.movieDetailResult = .success(.mock)
        service.movieCreditsResult = .success(.withDirector)
        
        let viewModel = DetailViewModel(mediaType: .movie(id: 1), service: service)
        await viewModel.loadDetail()
        
        #expect(viewModel.movieDetail?.title == "Mock Movie Detail")
        #expect(viewModel.credits?.director?.name == "Jane Doe")
        #expect(viewModel.tvShowDetail == nil)
        #expect(viewModel.isLoading == false)
    }
    
    @MainActor
    @Test("loads TV show detail successfully")
    func loadTVShowDetail_success() async {
        let service = MockTMDBService()
        service.tvShowDetailResult = .success(.mock)
        service.tvShowCreditsResult = .success(.withDirector)
        
        let viewModel = DetailViewModel(mediaType: .tvShow(id: 1), service: service)
        await viewModel.loadDetail()
        
        #expect(viewModel.tvShowDetail?.name == "Mock Show Detail")
        #expect(viewModel.movieDetail == nil)
        #expect(viewModel.isLoading == false)
    }
    
    @MainActor
    @Test("sets errorMessage when movie detail fails")
    func loadMovieDetail_failure() async {
        let service = MockTMDBService()
        service.movieDetailResult = .failure(NetworkError.statusCode(404))
        
        let viewModel = DetailViewModel(mediaType: .movie(id: 999), service: service)
        await viewModel.loadDetail()
        
        #expect(viewModel.movieDetail == nil)
        #expect(viewModel.errorMessage != nil)
    }
    
    @MainActor
    @Test("credits failure does not set errorMessage")
    func loadCredits_silentFailure() async {
        let service = MockTMDBService()
        service.movieDetailResult = .success(.mock)
        service.movieCreditsResult = .failure(NetworkError.statusCode(500))
        
        let viewModel = DetailViewModel(mediaType: .movie(id: 1), service: service)
        await viewModel.loadDetail()
        
        #expect(viewModel.movieDetail != nil)
        #expect(viewModel.credits == nil)
        #expect(viewModel.errorMessage == nil) // falha silenciosa intencional
    }
}
