//
//  ArticleRowView.swift
//  RoxNewsReader
//
//  Created by Avanish Samala on 9/2/25.
//


import SwiftUI

struct ArticleRowView: View {
    let article: Article
    let isBookmarked: Bool
    let onToggleBookmark: () -> Void

    // NEW: optional filtering hooks (keeps BookmarksView working untouched)
    var currentCategory: Category? = nil
    var currentCompany: String? = nil
    var onSetCategory: ((Category) -> Void)? = nil
    var onSetCompany: ((String?) -> Void)? = nil  // pass nil to clear

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header line: source + date + bookmark
            HStack(spacing: 10) {
                // Tap source pill to filter by that company
                RoxPill(text: article.sourceName, icon: "bolt.fill")
                    .onTapGesture { onSetCompany?(article.sourceName) }

                Spacer()

                Text(DateFormats.displayString(from: article.publishedAt))
                    .font(Rox.Font.mono).foregroundStyle(Rox.textMuted)

                Button(action: onToggleBookmark) {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .imageScale(.medium)
                        .foregroundStyle(isBookmarked ? Rox.accent : Rox.textMuted)
                }
                .buttonStyle(.plain)
            }

            // Title
            Text(article.title)
                .font(Rox.Font.title)
                .foregroundStyle(Rox.textPrimary)
                .lineLimit(3)

            // Thumb
            if let img = article.imageURL {
                AsyncImage(url: img) { phase in
                    switch phase {
                    case .empty: Color.gray.opacity(0.15)
                    case .success(let image): image.resizable().scaledToFill()
                    case .failure: Color.gray.opacity(0.15)
                    @unknown default: Color.gray.opacity(0.15)
                    }
                }
                .frame(height: 148)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 10).fill(Rox.glow).frame(height: 40)
                        .blur(radius: 22).opacity(0.6)
                }
            }

            // Optional snippet
            if let desc = article.description, !desc.isEmpty {
                Text(desc).font(Rox.Font.body).foregroundStyle(Rox.textMuted).lineLimit(3)
            }

            // Inline filter controls (only shown when closures provided)
            if onSetCategory != nil || onSetCompany != nil {
                HStack(spacing: 8) {
                    if let onSetCategory {
                        Menu {
                            ForEach(Category.allCases) { cat in
                                Button(cat.rawValue.capitalized) { onSetCategory(cat) }
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                                Text(currentCategory.map { $0 == .all ? "All" : $0.rawValue.capitalized } ?? "Category")
                            }
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(Rox.textPrimary)
                            .padding(.horizontal, 10).padding(.vertical, 6)
                            .background(Capsule().fill(Rox.chip))
                        }
                        .buttonStyle(.plain)
                    }

                    if let onSetCompany {
                        if let comp = currentCompany, !comp.isEmpty {
                            Button { onSetCompany(nil) } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "xmark.circle.fill")
                                    Text(comp)
                                }
                                .font(.caption2)
                                .foregroundStyle(Rox.textMuted)
                                .padding(.horizontal, 10).padding(.vertical, 6)
                                .background(Capsule().fill(Rox.chip))
                            }
                            .buttonStyle(.plain)
                        } else {
                            Button { onSetCompany(article.sourceName) } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "target")
                                    Text("Filter \(article.sourceName)")
                                }
                                .font(.caption2)
                                .foregroundStyle(Rox.textMuted)
                                .padding(.horizontal, 10).padding(.vertical, 6)
                                .background(Capsule().fill(Rox.chip))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    Spacer(minLength: 0)
                }
                .padding(.top, 2)
            }
        }
        .roxCard()
        .contentShape(Rectangle())
        .contextMenu {
            if let onSetCategory {
                Menu("Set Category") {
                    ForEach(Category.allCases) { cat in
                        Button(cat.rawValue.capitalized) { onSetCategory(cat) }
                    }
                }
            }
            if let onSetCompany {
                Button("Filter by \(article.sourceName)") { onSetCompany(article.sourceName) }
                if let comp = currentCompany, !comp.isEmpty {
                    Button("Clear company filter (\(comp))", role: .destructive) { onSetCompany(nil) }
                }
            }
        }
    }
}
