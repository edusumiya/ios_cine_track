//
//  MediaCardView.swift
//  CineTrack
//
//  Created by Eduardo Sumiya on 20/03/26.
//

import SwiftUI

struct MediaCardView: View {
    let posterURL: URL?
    let title: String
    let rating: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            AsyncImage(url: posterURL) { phase in
                switch phase {
                case .empty:
                    posterPlaceholder
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    posterPlaceholder
                @unknown default:
                    posterPlaceholder
                }
            }
            .frame(width: 130, height: 195)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(2)
                .frame(width: 130, alignment: .leading)
            
            Label(rating, systemImage: "star.fill")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(width: 130)
    }
    
    // MARK: - Private Variables
    private var posterPlaceholder: some View {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.secondary.opacity(0.15))
                .overlay(
                    Image(systemName: "film")
                        .font(.title)
                        .foregroundStyle(.secondary)
                )
        }
}

#Preview {
//    MediaCardView()
}
