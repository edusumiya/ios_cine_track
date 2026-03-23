//
//  HomeViewModel.swift
//  CineTrack
//
//  Created by Eduardo Sumiya on 20/03/26.
//

import Foundation
import Observation

@Observable
final class HomeViewModel {
    // MARK: - State
    var nowPlayingMovies: [Movie] = []
    var popularMovies: [Movie] = []
    var topRatedMovies: [Movie] = []
    var popularTVShows: [TVShow] = []
    
    var isLoading = false
    var errorMessage: String?
    
    // MARK: - Dependencies
    private let service: TMDBService
    
    init(service: TMDBService = .shared) {
        self.service = service
    }
    
    // MARK: - Intent
    @MainActor
    func loadContent() async {
        isLoading = true
        errorMessage = nil
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchNowPlaying() }
            group.addTask { await self.fetchPopular() }
            group.addTask { await self.fetchTopRated() }
            group.addTask { await self.fetchPopularTVShows() }
        }
        
        isLoading = false
    }
    
    // MARK: - Private Fetches
    // Each fetch is isolated. If one fails, the others still succeed.
    private func fetchNowPlaying() async {
        do {
            let response = try await service.fetchNowPlaying()
            await MainActor.run { nowPlayingMovies = response.results }
        } catch {
            await MainActor.run { errorMessage = error.localizedDescription }
        }
    }
    
    private func fetchPopular() async {
        do {
            let response = try await service.fetchPopularMovies()
            await MainActor.run { popularMovies = response.results }
        } catch {
            await MainActor.run { errorMessage = error.localizedDescription }
        }
    }
    
    private func fetchTopRated() async {
        do {
            let response = try await service.fetchTopRated()
            await MainActor.run { topRatedMovies = response.results }
        } catch {
            await MainActor.run { errorMessage = error.localizedDescription }
        }
    }
    
    private func fetchPopularTVShows() async {
        do {
            let response = try await service.fetchPopularTVShows()
            await MainActor.run { popularTVShows = response.results }
        } catch {
            await MainActor.run { errorMessage = error.localizedDescription }
        }
    }
}
