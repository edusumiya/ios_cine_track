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
    var credits: Credits?
    
    var isLoading = false
    var errorMessage: String?
    
    // MARK: - Dependencies
    private var movieId: Int
    private let service: TMDBService
    
    init(movieId: Int, service: TMDBService = .shared) {
        self.movieId = movieId
        self.service = service
    }
    
    @MainActor
    func loadDetail() async {
        isLoading = true
        errorMessage = nil
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchDetail() }
            group.addTask { await self.fetchCredits() }
        }
        
        isLoading = false
    }
    
    // MARK: - Private Methods
    private func fetchDetail() async {
        do {
            let detail = try await service.fetchMovieDetail(id: movieId)
            
            await MainActor.run { movieDetail = detail }
        } catch {
            await MainActor.run { errorMessage = error.localizedDescription }
        }
    }
    
    private func fetchCredits() async {
        do {
            let credits = try await service.fetchMovieCredits(id: movieId)
            
            await MainActor.run { self.credits = credits }
        } catch {
            // Credits failing silently is acceptable UX —
            // the detail page is still useful without cast info.
            print("Credits fetch failed: \(error)")
        }
    }
}
