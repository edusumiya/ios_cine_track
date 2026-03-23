//
//  SearchView.swift
//  CineTrack
//
//  Created by Eduardo Sumiya on 20/03/26.
//

import SwiftUI

struct SearchView: View {
    @State private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isEmpty {
                    emptyPrompt
                } else if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.showEmptyState {
                    noResultsView
                } else {
                    resultsList
                }
            }
            .navigationTitle("Search")
            // searchable attaches a native search bar to the NavigationStack
            .searchable(text: $viewModel.query, prompt: "Movies, TV shows...")
            // .task(id:) is the SwiftUI-native debounce pattern.
            // It cancels and restarts the async task every time 'query' changes.
            // Combined with a sleep, this creates debounce without Combine.
            .task(id: viewModel.query) {
                do {
                    // Wait 300ms before searching — avoids firing on every keystroke
                    try await Task.sleep(for: .milliseconds(300))
                    await viewModel.search()
                } catch {
                    // Task.sleep throws CancellationError when cancelled — that's expected here.
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var emptyPrompt: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("Search for movies")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
    }
    
    private var noResultsView: some View {
        VStack(spacing: 12) {
            Image(systemName: "film.slash")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No results for \(viewModel.query)")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
    }
    
    private var resultsList: some View {
        List(viewModel.results) { movie in
            NavigationLink(value: movie) {
                SearchResultRow(movie: movie)
            }
        }
        .listStyle(.plain)
        .navigationDestination(for: Movie.self) { movie in
            DetailView(mediaType: .movie(id: movie.id))
        }
    }
}

struct SearchResultRow: View {
    let movie: Movie
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: movie.posterURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.secondary.opacity(0.2))
            }
            .frame(width: 50, height: 75)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(movie.releaseYear)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Label(movie.formattedRating, systemImage: "star.fill")
                    .font(.caption)
                    .foregroundStyle(.yellow)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    SearchView()
}
