//
//  HomeView.swift
//  CineTrack
//
//  Created by Eduardo Sumiya on 20/03/26.
//

import SwiftUI

struct HomeView: View {
    
    @State private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.popularMovies.isEmpty {
                    LoadingView()
                } else {
                    contentView
                }
            }
            .navigationTitle("Cine Track")
            .navigationBarTitleDisplayMode(.large)
        }
        .task {
            await viewModel.loadContent()
        }
        .alert("Something went wrong", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("Retry") { Task { await viewModel.loadContent() } }
            Button("Cancel", role: .cancel) { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
    
    private var contentView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 32) {
                MovieSectionView(
                    title: "Now Playing",
                    movies: viewModel.nowPlayingMovies
                )
                MovieSectionView(
                    title: "Popular",
                    movies: viewModel.popularMovies
                )
                MovieSectionView(
                    title: "Top Rated",
                    movies: viewModel.topRatedMovies
                )
                TVShowSectionView(
                    title: "Popular TV Shows",
                    shows: viewModel.popularTVShows
                )
            }
            .padding(.vertical)
        }
        .navigationDestination(for: Movie.self) { movie in
            DetailView(movieId: movie.id)
        }
        .navigationDestination(for: TVShow.self) { show in
            DetailView(movieId: show.id)
        }
    }
}

// MARK: - SubViews
struct MovieSectionView: View {
    let title: String
    let movies: [Movie]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(movies) { movie in
                        NavigationLink(value: movie) {
                            MediaCardView(
                                posterURL: movie.posterURL,
                                title: movie.title, rating:
                                    movie.formattedRating
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct TVShowSectionView: View {
    let title: String
    let shows: [TVShow]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(shows) { show in
                        NavigationLink(value: show) {
                            MediaCardView(
                                posterURL: show.posterURL,
                                title: show.name,
                                rating: show.formattedRating
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    HomeView()
}
