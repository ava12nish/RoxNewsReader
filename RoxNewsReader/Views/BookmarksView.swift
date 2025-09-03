//
//  BookmarksView.swift
//  RoxNewsReader
//
//  Created by Avanish Samala on 9/2/25.
//


import SwiftUI

struct BookmarksView: View {
    @EnvironmentObject private var bookmarks: BookmarkStore

    var body: some View {
        NavigationStack {
            ZStack {
                Rox.bg.ignoresSafeArea()
                if bookmarks.items.isEmpty {
                    VStack(spacing: 12) {
                        Text("No bookmarks yet.")
                            .foregroundStyle(Rox.textPrimary)
                        Text("Save articles to read later.")
                            .foregroundStyle(Rox.textMuted)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 14) {
                            ForEach(bookmarks.items, id: \.id) { article in
                                NavigationLink {
                                    ArticleDetailView(article: article)
                                } label: {
                                    ArticleRowView(
                                        article: article,
                                        isBookmarked: true,
                                        onToggleBookmark: { bookmarks.toggle(article) }
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .navigationTitle("Bookmarks")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Rox.bg, for: .navigationBar)
        }
        .tint(Rox.accent)
    }
}
