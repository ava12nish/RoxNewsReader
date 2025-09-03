//
//  FeedView.swift
//  RoxNewsReader
//
//  Created by Avanish Samala on 9/2/25.
//

import SwiftUI

struct FeedView: View {
    @StateObject private var vm = FeedViewModel()
    @EnvironmentObject private var bookmarks: BookmarkStore
    @State private var searchDebounceTask: Task<Void, Never>? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Rox.bg.ignoresSafeArea()
                VStack(spacing: 0) {
                    ScrollView {

                        // ⬇️ Moved here so it stays at the TOP
                        HStack {
                            Picker("Category", selection: $vm.selectedCategory) {
                                ForEach(Category.allCases) { cat in
                                    Text(cat.rawValue.capitalized).tag(cat)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(Rox.accent)

                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        .padding(.bottom, 4)

                        LazyVStack(spacing: 14) {
                            if vm.isLoading && vm.articles.isEmpty {
                                ProgressView("Loading headlines…")
                                    .font(Rox.Font.body)
                                    .tint(Rox.accent)
                                    .frame(maxWidth: .infinity, minHeight: 240)
                            } else if let error = vm.error, vm.articles.isEmpty {
                                VStack(spacing: 12) {
                                    Text(error)
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(Rox.textMuted)
                                    Button("Retry") { vm.refresh() }
                                        .buttonStyle(RoxPrimaryButtonStyle())
                                }
                                .frame(maxWidth: .infinity, minHeight: 240)
                            } else if vm.articles.isEmpty {
                                VStack(spacing: 12) {
                                    Text("No articles found.")
                                        .foregroundStyle(Rox.textMuted)
                                    Button("Refresh") { vm.refresh() }
                                        .buttonStyle(RoxPrimaryButtonStyle())
                                }
                                .frame(maxWidth: .infinity, minHeight: 240)
                            } else {
                                // Current filters banner (shows selected category/company)
                                if !vm.company.isEmpty {
                                    HStack(spacing: 8) {
                                        if !vm.company.isEmpty {
                                            Button {
                                                vm.company = ""
                                                vm.refresh()
                                            } label: {
                                                RoxPill(text: "Company: " + vm.company + "  ✕")
                                            }
                                            .buttonStyle(.plain)
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal, 2)
                                    .padding(.bottom, 4)
                                }

                                // Cards
                                ForEach(vm.articles, id: \.id) { article in
                                    NavigationLink {
                                        ArticleDetailView(article: article)
                                    } label: {
                                        ArticleRowView(
                                            article: article,
                                            isBookmarked: bookmarks.isBookmarked(article),
                                            onToggleBookmark: { bookmarks.toggle(article) },
                                            // pass filtering context + actions
                                            currentCategory: vm.selectedCategory,
                                            currentCompany: vm.company.isEmpty ? nil : vm.company,
                                            onSetCategory: { newCat in
                                                if vm.selectedCategory != newCat {
                                                    vm.selectedCategory = newCat
                                                    vm.refresh()
                                                }
                                            },
                                            onSetCompany: { comp in
                                                vm.company = comp?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                                                vm.refresh()
                                            }
                                        )
                                        .onAppear { vm.loadNextPageIfNeeded(currentItem: article) }
                                    }
                                    .buttonStyle(.plain)
                                }

                                if vm.isLoading && !vm.articles.isEmpty {
                                    ProgressView()
                                        .padding(.vertical, 12)
                                        .tint(Rox.accent)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                }
            }
            .navigationTitle("Top Headlines")
            .toolbarBackground(Rox.bg, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .searchable(
                text: $vm.search,
                placement: .navigationBarDrawer(displayMode: .automatic),
                prompt: "Search headlines"
            )
            .onSubmit(of: .search) { vm.refresh() }
            .onChange(of: vm.search) { _, _ in
                searchDebounceTask?.cancel()
                searchDebounceTask = Task { @MainActor in
                    try? await Task.sleep(nanoseconds: 400_000_000)
                    if !Task.isCancelled { vm.refresh() }
                }
            }
            .task { vm.refresh() }
        }
        .tint(Rox.accent)
    }
}
