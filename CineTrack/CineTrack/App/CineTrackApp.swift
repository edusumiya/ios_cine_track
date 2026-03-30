//
//  CineTrackApp.swift
//  CineTrack
//
//  Created by Eduardo Sumiya on 20/03/26.
//

import SwiftUI
import SwiftData

@main
struct CineTrackApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                
                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                
                LibraryView()
                    .tabItem {
                        Label("Library", systemImage: "books.vertical.fill")
                    }
            }
        }
        // it uses injection of SwiftData in all child views environment
        .modelContainer(for: SavedMedia.self)
    }
}
