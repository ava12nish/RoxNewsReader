//
//  FeedViewModel.swift
//  RoxNewsReader
//
//  Created by Avanish Samala on 9/2/25.
//


import Foundation

@MainActor
final class FeedViewModel: ObservableObject {
    @Published private(set) var articles: [Article] = []
    @Published var isLoading = false
    @Published var error: String? = nil
    @Published var hasMore = true
    
    

    // Filters
    @Published var selectedCategory: Category = .all {
        didSet { refresh() }
    }
    @Published var company: String = "" // free text
    @Published var search: String = ""  // optional search

    private var currentPage = 1
    private var totalResults = 0

    func refresh() {
        currentPage = 1
        hasMore = true
        articles = []
        Task { await load() }
    }

    func loadNextPageIfNeeded(currentItem item: Article?) {
        guard let item else { return }
        let thresholdIndex = max(0, articles.count - 5)
        if articles.firstIndex(of: item) == thresholdIndex {
            Task { await load() }
        }
    }

    func load() async {
        guard !isLoading, hasMore else { return }
        isLoading = true; error = nil

        let q = NewsAPIClient.Query(
            page: currentPage,
            pageSize: Config.pageSize,
            country: Config.country,
            category: selectedCategory,
            company: company.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : company,
            search: search.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : search
        )

        do {
            let (newArticles, total) = try await NewsAPIClient.shared.topHeadlines(q)
            totalResults = total
            if currentPage == 1 {
                articles = newArticles
            } else {
                // de-dupe on id
                let existing = Set(articles.map { $0.id })
                let filtered = newArticles.filter { !existing.contains($0.id) }
                articles.append(contentsOf: filtered)
            }
            currentPage += 1
            hasMore = articles.count < totalResults
        } catch {
            self.error = (error as? LocalizedError)?.errorDescription ?? "Something went wrong."
        }

        isLoading = false
    }
}
