//
//  DetailViewModel.swift
//  CineTrack
//
//  Created by Eduardo Sumiya on 20/03/26.
//

import Foundation
import Observation

@Observable
final class DetailViewModel {
    
    // MARK: - State
    var movieDetail: MovieDetail?
    var tvShowDetail: TVShowDetail?
    var credits: Credits?
    
    var isLoading = false
    var errorMessage: String?
    
    // MARK: - Dependencies
    private let mediaType: MediaType
    private let service: any TMDBServiceProtocol
    
    init(mediaType: MediaType, service: any TMDBServiceProtocol = TMDBService.shared) {
        self.mediaType = mediaType
        self.service = service
    }
    
    @MainActor
    func loadDetail() async {
        isLoading = true
        errorMessage = nil
        
        switch mediaType {
        case .movie(let id):
            await withTaskGroup(of: Void.self) { group in
                group.addTask { await self.fetchMovieDetail(id: id) }
                group.addTask { await self.fetchMovieCredits(id: id) }
            }
        case .tvShow(let id):
            await withTaskGroup(of: Void.self) { group in
                group.addTask { await self.fetchTVShowDetail(id: id) }
                group.addTask { await self.fetchTVShowCredits(id: id) }
            }
        }
        
        isLoading = false
    }
    
    // MARK: - Private Methods
    private func fetchMovieDetail(id: Int) async {
        do {
            let detail = try await service.fetchMovieDetail(id: id)
            
            await MainActor.run { movieDetail = detail }
        } catch {
            await MainActor.run { errorMessage = error.localizedDescription }
        }
    }
    
    private func fetchMovieCredits(id: Int) async {
        do {
            let credits = try await service.fetchMovieCredits(id: id)
            
            await MainActor.run { self.credits = credits }
        } catch {
            // Credits failing silently is acceptable UX —
            // the detail page is still useful without cast info.
            print("Movie redits fetch failed: \(error)")
        }
    }
    
    private func fetchTVShowDetail(id: Int) async {
        do {
            let detail = try await service.fetchTVShowDetail(id: id)
            
            await MainActor.run { tvShowDetail = detail }
        } catch {
            await MainActor.run { errorMessage = error.localizedDescription }
        }
    }
    
    private func fetchTVShowCredits(id: Int) async {
        do {
            let credits = try await service.fetchTVShowCredits(id: id)
            
            await MainActor.run { self.credits = credits }
        } catch {
            // Credits failing silently is acceptable UX —
            // the detail page is still useful without cast info.
            print("TV credits fetch failed: \(error)")
        }
    }
}
