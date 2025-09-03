//
//  NewsAPIClient.swift
//  RoxNewsReader
//
//  Created by Avanish Samala on 9/2/25.
//

import Foundation

enum APIError: Error, LocalizedError {
    case missingAPIKey
    case badURL
    case http(Int)
    case decoding
    case unknown

    var errorDescription: String? {
        switch self {
        case .missingAPIKey: return "API key is missing."
        case .badURL: return "Bad URL."
        case .http(let code): return "HTTP error \(code)."
        case .decoding: return "Failed to decode response."
        case .unknown: return "Unknown error."
        }
    }
}

final class NewsAPIClient {
    static let shared = NewsAPIClient()
    private init() {}

    private let base = URL(string: "https://newsapi.org/v2")!

    struct Query {
        var page: Int = 1
        var pageSize: Int = Config.pageSize
        var country: String = Config.country
        var category: Category = .all
        var company: String? = nil  // e.g. "Apple", "Tesla"
        var search: String? = nil   // optional generic search
    }

    func topHeadlines(_ q: Query) async throws -> (articles: [Article], total: Int) {
        guard !Secrets.newsAPIKey.isEmpty else { throw APIError.missingAPIKey }

        var url = base.appendingPathComponent("top-headlines")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        var items: [URLQueryItem] = [
            .init(name: "page", value: String(q.page)),
            .init(name: "pageSize", value: String(q.pageSize))
        ]

        // If filtering by search/company, NewsAPI rules:
        // Either specify 'country' or 'sources' or 'q'. If 'q' present, country can still be used.
        items.append(.init(name: "country", value: q.country))

        if let cat = q.category.apiValue {
            items.append(.init(name: "category", value: cat))
        }

        // Company filter implemented via 'q' keyword search
        let compositeQuery: String? = {
            switch (q.company, q.search) {
            case (nil, nil): return nil
            case let (c?, nil): return c
            case let (nil, s?): return s
            case let (c?, s?): return "\(s) \(c)"
            }
        }()
        if let qstr = compositeQuery, !qstr.trimmingCharacters(in: .whitespaces).isEmpty {
            items.append(.init(name: "q", value: qstr))
        }

        components.queryItems = items
        guard let finalURL = components.url else { throw APIError.badURL }
        url = finalURL

        var req = URLRequest(url: url)
        req.addValue(Secrets.newsAPIKey, forHTTPHeaderField: "X-Api-Key")

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else { throw APIError.unknown }
        guard (200..<300).contains(http.statusCode) else { throw APIError.http(http.statusCode) }

        do {
            let decoded = try JSONDecoder().decode(NewsAPIResponse.self, from: data)
            let mapped = decoded.articles.compactMap(Article.init(dto:))
            return (mapped, decoded.totalResults)
        } catch {
            throw APIError.decoding
        }
    }
}
