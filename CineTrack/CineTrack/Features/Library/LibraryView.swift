//
//  LibraryView.swift
//  CineTrack
//
//  Created by Eduardo Sumiya on 23/03/26.
//

import SwiftUI
import SwiftData

struct LibraryView: View {
    
    @State private var selectedList: SavedListType = .favorite
    @State private var selectedMediaType: SavedMediaType = .movie
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("List", selection: $selectedList) {
                    ForEach(SavedListType.allCases, id: \.self) { list in
                        Label(list.title, systemImage: list.icon)
                            .tag(list)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                Picker("Media Type", selection: $selectedMediaType) {
                    Text("Movies").tag(SavedMediaType.movie)
                    Text("TV Shows").tag(SavedMediaType.tvShow)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.bottom)
                
                SavedMediaListView(
                    listType: selectedList,
                    mediaType: selectedMediaType
                )
            }
        }
    }
}

struct SavedMediaListView: View {
    let listType: SavedListType
    let mediaType: SavedMediaType
    
    @Query private var items: [SavedMedia]
    @Environment(\.modelContext) private var context
    
    init(listType: SavedListType, mediaType: SavedMediaType) {
        self.listType = listType
        self.mediaType = mediaType
        
        let listRaw = listType.rawValue
        let mediaRaw = mediaType.rawValue
        
        //Dynamic query filter - passed in init
        _items = Query(
                filter: #Predicate<SavedMedia> { item in
                    item.listTypeRaw == listRaw &&
                    item.mediaTypeRaw == mediaRaw
                },
                sort: \SavedMedia.savedAt,
                order: .reverse
            )
    }
    
    var body: some View {
        if items.isEmpty {
            emptyState
        } else {
            List {
                ForEach(items) { item in
                    NavigationLink(value: item) {
                        SavedMediaRow(item: item)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        context.delete(items[index])
                    }
                }
            }
            .listStyle(.plain)
            .navigationDestination(for: SavedMedia.self) { item in
                let mediaType: MediaType = item.mediaType == .movie
                ? .movie(id: item.mediaId)
                : .tvShow(id: item.mediaId)
                DetailView(mediaType: mediaType)
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: listType.icon)
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No \(listType.title) yet")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SavedMediaRow: View {
    let item: SavedMedia
    
    var body: some View {
        HStack(spacing: 12) {
                    AsyncImage(url: item.posterURL) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle().fill(Color.secondary.opacity(0.2))
                    }
                    .frame(width: 50, height: 75)
                    .clipShape(RoundedRectangle(cornerRadius: 6))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .font(.headline)
                            .lineLimit(2)
                        Text(item.releaseYear)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Label(item.formattedRating, systemImage: "star.fill")
                            .font(.caption)
                            .foregroundStyle(.yellow)
                    }
                }
                .padding(.vertical, 4)
    }
}

#Preview {
    LibraryView()
}
