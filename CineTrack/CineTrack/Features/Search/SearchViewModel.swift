//
//  SearchViewModel.swift
//  CineTrack
//
//  Created by Eduardo Sumiya on 23/03/26.
//

import Foundation
import Observation

@Observable
final class SearchViewModel {
    // MARK: - State
    var query: String = ""
    var results: [Movie] = []
    
    
    var isLoading: Bool = false
    var errorMessage: String?
    
    var isEmpty: Bool { query.isEmpty }
    var hasResults: Bool { !results.isEmpty }
    var showEmptyState: Bool { !query.isEmpty && !isLoading && results.isEmpty }
    
    private let service: any TMDBServiceProtocol
    
    init(service: any TMDBServiceProtocol = TMDBService.shared) {
        self.service = service
    }
    
    @MainActor
    func search() async {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        
        guard trimmed.count >= 2 else {
            results = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await service.searchMovies(query: trimmed)
            results = response.results
        } catch {
            errorMessage = error.localizedDescription
            results = []
        }
        
        isLoading = false
    }
    
    
    func clearSearch() {
        query = ""
        results.removeAll()
        errorMessage = nil
    }
}
