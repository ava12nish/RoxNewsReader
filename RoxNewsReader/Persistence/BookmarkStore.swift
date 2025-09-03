//
//  BookmarkStore.swift
//  RoxNewsReader
//
//  Created by Avanish Samala on 9/2/25.
//


import Foundation
import SwiftUI

@MainActor
final class BookmarkStore: ObservableObject {
    @Published private(set) var items: [Article] = []

    private let fileURL: URL = {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("bookmarks.json")
    }()

    init() {
        Task { await load() }
    }

    func isBookmarked(_ article: Article) -> Bool {
        items.contains(article)
    }

    func toggle(_ article: Article) {
        if let idx = items.firstIndex(of: article) {
            items.remove(at: idx)
        } else {
            items.insert(article, at: 0)
        }
        Task { await save() }
    }

    func remove(_ article: Article) {
        items.removeAll { $0 == article }
        Task { await save() }
    }

    private func save() async {
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Bookmark save error:", error)
        }
    }

    private func load() async {
        do {
            let data = try Data(contentsOf: fileURL)
            let decoded = try JSONDecoder().decode([Article].self, from: data)
            self.items = decoded
        } catch {
            // first launch or error, ignore
        }
    }
}
