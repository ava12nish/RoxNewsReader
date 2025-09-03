//
//  ContentView.swift
//  RoxNewsReader
//
//  Created by Avanish Samala on 9/2/25.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Label("Feed", systemImage: "newspaper")
                }

            BookmarksView()
                .tabItem {
                    Label("Bookmarks", systemImage: "bookmark")
                }
        }
    }
}


#Preview {
    ContentView()
            .environmentObject(BookmarkStore())
}
