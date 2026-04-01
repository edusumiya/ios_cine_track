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
    private let sharedModelContainer: ModelContainer

    init() {
        do {
            let isUITesting = ProcessInfo.processInfo.arguments.contains("UI_TESTING")
            let configuration = ModelConfiguration(
                isStoredInMemoryOnly: isUITesting
            )

            sharedModelContainer = try ModelContainer(
                for: SavedMedia.self,
                configurations: configuration
            )
        } catch {
            fatalError("Failed to create model container: \(error)")
        }
    }

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
        .modelContainer(sharedModelContainer)
    }
}
