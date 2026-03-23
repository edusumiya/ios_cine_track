//
//  DetailView.swift
//  CineTrack
//
//  Created by Eduardo Sumiya on 20/03/26.
//

import SwiftUI

struct DetailView: View {
    let movieId: Int
    
    @State private var viewModel: DetailViewModel
    
    init(movieId: Int) {
        self.movieId = movieId
        
        _viewModel = State(initialValue: DetailViewModel(movieId: movieId))
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else if let detail = viewModel.movieDetail {
                detailContent(detail)
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
    
    @ViewBuilder
    private func detailContent(_ detail: MovieDetail) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                //Backdrop
                backdropSection(detail)
                
                VStack(alignment: .leading, spacing: 20) {
                    //Title + metadata
                    headerSection(detail)
                    
                    //Genres
                    if !detail.genres.isEmpty {
                        genresSection(detail.genres)
                    }
                    
                    //Overview
                    overviewSection(detail)
                    
                    //Cast
                    if let credits = viewModel.credits, !credits.topCast.isEmpty {
                        castSection(credits.topCast)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .top)
    }
    
    // MARK: - SubViews
    private func backdropSection(_ detail: MovieDetail) -> some View {
        AsyncImage(url: detail.backdropURL) { image in
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
    
    private func headerSection(_ detail: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(detail.title)
                .font(.title)
                .fontWeight(.bold)
            
            if let tagline = detail.tagline, !tagline.isEmpty {
                Text(tagline)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .italic()
            }
            
            HStack(spacing: 16) {
                Label(detail.formattedRating, systemImage: "star.fill")
                    .foregroundStyle(.yellow)
                
                Text(detail.releaseYear)
                    .foregroundStyle(.secondary)
                
                Text(detail.formattedRuntime)
                    .foregroundStyle(.secondary)
                
                if let director = viewModel.credits?.director {
                    Text ("Dir. \(director.name)")
                        .foregroundStyle(.secondary)
                }
            }
            .font(.subheadline)
        }
    }
    
    private func genresSection(_ genres: [Genre]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(genres) { genre in
                    Text(genre.name)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.accentColor.opacity(0.15))
                        .foregroundStyle(Color.accentColor)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(.leading)
    }
    
    private func overviewSection(_ detail: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Overview")
                .font(.headline)
            Text(detail.overview)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private func castSection(_ cast: [CastMember]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cast")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 12) {
                    ForEach(cast) { member in
                        CastCardView(member: member)
                    }
                }
            }
        }
        .padding()
    }
    
    private var credits: Credits? {
        viewModel.credits
    }
}

#Preview {
    DetailView(movieId: 25)
}
