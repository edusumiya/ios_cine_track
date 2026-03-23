//
//  DetailView.swift
//  CineTrack
//
//  Created by Eduardo Sumiya on 20/03/26.
//

import SwiftUI

struct DetailView: View {
    let mediaType: MediaType
    
    @State private var viewModel: DetailViewModel
    
    init(mediaType: MediaType) {
        self.mediaType = mediaType
        _viewModel = State(initialValue: DetailViewModel(mediaType: mediaType))
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else if let detail = viewModel.movieDetail {
                movieContent(detail)
            } else if let detail = viewModel.tvShowDetail {
                tvShowContent(detail)
            }
        }
        .task {
            await viewModel.loadDetail()
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("Retry") { Task { await viewModel.loadDetail() } }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
    
    // MARK: - Movie Content
    @ViewBuilder
    private func movieContent(_ detail: MovieDetail) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                backdropSection(url: detail.backdropURL)
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text(detail.title).font(.title).fontWeight(.bold)
                        if let tagline = detail.tagline, !tagline.isEmpty {
                            Text(tagline).font(.subheadline).foregroundStyle(.secondary).italic()
                        }
                        HStack(spacing: 16) {
                            Label(detail.formattedRating, systemImage: "star.fill").foregroundStyle(.yellow)
                            Text(detail.releaseYear).foregroundStyle(.secondary)
                            Text(detail.formattedRuntime).foregroundStyle(.secondary)
                            if let director = viewModel.credits?.director {
                                Text("Dir. \(director.name)").foregroundStyle(.secondary)
                            }
                        }
                        .font(.subheadline)
                    }
                    genresSection(detail.genres)
                    overviewSection(detail.overview)
                    if let credits = viewModel.credits, !credits.topCast.isEmpty {
                        castSection(credits.topCast)
                    }
                }
                .padding(.horizontal)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - TVShow Content
    @ViewBuilder
    private func tvShowContent(_ detail: TVShowDetail) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                backdropSection(url: detail.backdropURL)
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text(detail.name).font(.title).fontWeight(.bold)
                        if let tagline = detail.tagline, !tagline.isEmpty {
                            Text(tagline).font(.subheadline).foregroundStyle(.secondary).italic()
                        }
                        HStack(spacing: 16) {
                            Label(detail.formattedRating, systemImage: "star.fill").foregroundStyle(.yellow)
                            Text(detail.firstAirYear).foregroundStyle(.secondary)
                            Text(detail.formattedSeasons).foregroundStyle(.secondary)
                            Text(detail.formattedRuntime).foregroundStyle(.secondary)
                        }
                        .font(.subheadline)
                    }
                    genresSection(detail.genres)
                    overviewSection(detail.overview)
                    if let credits = viewModel.credits, !credits.topCast.isEmpty {
                        castSection(credits.topCast)
                    }
                }
                .padding(.horizontal)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    // MARK: - SubViews
    private func backdropSection(url: URL?) -> some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Rectangle()
                .fill(Color.secondary.opacity(0.2))
        }
        .frame(maxHeight: 280)
        .clipped()
        .overlay(
            LinearGradient(
                colors: [.clear, Color(.systemBackground)],
                startPoint: .center,
                endPoint: .bottom
            )
        )
    }
    
    private func genresSection(_ genres: [Genre]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(genres) { genre in
                    Text(genre.name)
                        .font(.caption).fontWeight(.medium)
                        .padding(.horizontal, 12).padding(.vertical, 6)
                        .background(Color.accentColor.opacity(0.15))
                        .foregroundStyle(Color.accentColor)
                        .clipShape(Capsule())
                }
            }
            .padding(.leading)
        }
    }
    
    private func overviewSection(_ overview: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Overview").font(.headline)
            Text(overview).font(.body).foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private func castSection(_ cast: [CastMember]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cast").font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 12) {
                    ForEach(cast) { member in
                        CastCardView(member: member)
                    }
                }
            }
        }
    }
    
    private var credits: Credits? {
        viewModel.credits
    }
}

#Preview {
    DetailView(mediaType: .movie(id: 25))
}
