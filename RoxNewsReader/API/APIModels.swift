//
//  APIModels.swift
//  RoxNewsReader
//
//  Created by Avanish Samala on 9/2/25.
//

import Foundation

struct NewsAPIResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [ArticleDTO]
}

struct ArticleDTO: Decodable {
    struct SourceDTO: Decodable {
        let id: String?
        let name: String
    }
    let source: SourceDTO
    let author: String?
    let title: String?
    let description: String?
    let url: URL?
    let urlToImage: URL?
    let publishedAt: String?
    let content: String?
}

// App model used across UI
struct Article: Identifiable, Codable, Hashable {
    let id: String                // stable ID: prefer URL; fallback to title+date
    let sourceName: String
    let title: String
    let description: String?
    let url: URL
    let imageURL: URL?
    let publishedAt: Date?

    init?(dto: ArticleDTO) {
        guard let title = dto.title,
              let url = dto.url else { return nil }

        // Parse date
        let publishedAt: Date? = {
            // Try full ISO 8601 with fractional seconds, then without
            if let s = dto.publishedAt {
                if let d = DateFormats.api.date(from: s) {
                    return d
                }
                // fallback: ISO8601 without fractional seconds
                let f = ISO8601DateFormatter()
                if let d2 = f.date(from: s) { return d2 }
            }
            return nil
        }()

        self.id = (url.absoluteString.isEmpty ? "\(title)\(dto.publishedAt ?? "")" : url.absoluteString)
        self.sourceName = dto.source.name
        self.title = title
        self.description = dto.description
        self.url = url
        self.imageURL = dto.urlToImage
        self.publishedAt = publishedAt
    }
}

enum Category: String, CaseIterable, Identifiable {
    case all = "All"
    case business, entertainment, general, health, science, sports, technology
    var id: String { rawValue }
    var apiValue: String? { self == .all ? nil : rawValue }
}
