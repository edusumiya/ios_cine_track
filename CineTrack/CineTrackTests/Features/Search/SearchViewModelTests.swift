//
//  SearchViewModelTests.swift
//  CineTrack
//
//  Created by Eduardo Sumiya on 30/03/26.
//

import Testing
@testable import CineTrack

@Suite("SearchViewModel")
struct SearchViewModelTests {

    @MainActor
    @Test("returns empty results for short query")
    func search_shortQuery() async {
        let service = MockTMDBService()
        let viewModel = SearchViewModel(service: service)
        viewModel.query = "a"
        await viewModel.search()

        #expect(viewModel.results.isEmpty)
        #expect(service.searchMoviesCallCount == 0)
    }

    @MainActor
    @Test("searches when query has 2 or more characters")
    func search_validQuery() async {
        let service = MockTMDBService()
        service.searchResult = .success(.with([.mock(title: "Inception")]))

        let viewModel = SearchViewModel(service: service)
        viewModel.query = "Inc"
        await viewModel.search()

        #expect(viewModel.results.count == 1)
        #expect(viewModel.results.first?.title == "Inception")
        #expect(service.lastSearchQuery == "Inc")
    }

    @MainActor
    @Test("clears results on empty query")
    func search_emptyQuery() async {
        let service = MockTMDBService()
        let viewModel = SearchViewModel(service: service)
        viewModel.query = ""
        await viewModel.search()

        #expect(viewModel.results.isEmpty)
        #expect(viewModel.isLoading == false)
    }

    @MainActor
    @Test("sets errorMessage on failure")
    func search_failure() async {
        let service = MockTMDBService()
        service.searchResult = .failure(NetworkError.invalidResponse)

        let viewModel = SearchViewModel(service: service)
        viewModel.query = "Batman"
        await viewModel.search()

        #expect(viewModel.results.isEmpty)
        #expect(viewModel.errorMessage != nil)
    }

    @MainActor
    @Test("clearSearch resets state")
    func clearSearch() async {
        let service = MockTMDBService()
        service.searchResult = .success(.with([.mock()]))

        let viewModel = SearchViewModel(service: service)
        viewModel.query = "Test"
        await viewModel.search()
        viewModel.clearSearch()

        #expect(viewModel.query.isEmpty)
        #expect(viewModel.results.isEmpty)
        #expect(viewModel.errorMessage == nil)
    }
}
