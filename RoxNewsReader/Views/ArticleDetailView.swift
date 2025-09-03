//
//  ArticleDetailView.swift
//  RoxNewsReader
//
//  Created by Avanish Samala on 9/2/25.
//


import SwiftUI

struct ArticleDetailView: View {
    let article: Article
    @EnvironmentObject private var bookmarks: BookmarkStore
    @State private var showSafari = false

    var body: some View {
        ZStack {
            Rox.bg.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Hero image
                    if let url = article.imageURL {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty: Color.gray.opacity(0.15)
                            case .success(let image): image.resizable().scaledToFill()
                            case .failure: Color.gray.opacity(0.15)
                            @unknown default: Color.gray.opacity(0.15)
                            }
                        }
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 16).fill(Rox.glow).frame(height: 50)
                                .blur(radius: 24).opacity(0.7)
                        }
                    }

                    // Card with metadata + body
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 10) {
                            RoxPill(text: article.sourceName, icon: "bolt.fill")
                            Spacer()
                            Button {
                                bookmarks.toggle(article)
                            } label: {
                                Image(systemName: bookmarks.isBookmarked(article) ? "bookmark.fill" : "bookmark")
                                    .foregroundStyle(bookmarks.isBookmarked(article) ? Rox.accent : Rox.textMuted)
                            }.buttonStyle(.plain)
                        }

                        Text(article.title)
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(Rox.textPrimary)

                        Text(DateFormats.displayString(from: article.publishedAt))
                            .font(Rox.Font.mono)
                            .foregroundStyle(Rox.textMuted)

                        if let desc = article.description, !desc.isEmpty {
                            Text(desc)
                                .font(Rox.Font.body)
                                .foregroundStyle(Rox.textPrimary)
                        }

                        HStack {
                            Button("Open Original") { showSafari = true }
                                .buttonStyle(RoxPrimaryButtonStyle())
                            Spacer()
                        }
                    }
                    .roxCard()

                    // (Optional) Future: Insights / Notes sections can be more Rox panels
                }
                .padding(16)
            }
        }
        .navigationTitle("Article")
        .sheet(isPresented: $showSafari) { SafariView(url: article.url) }
    }
}
