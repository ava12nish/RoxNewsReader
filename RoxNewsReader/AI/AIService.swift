//
//  AIService.swift
//  RoxNewsReader
//
//  Created by Avanish Samala on 9/2/25.
//

import Foundation

struct AISummary: Codable {
    var paragraph: String
    var bullets: [String]
    var tags: [String]
}

enum AIError: Error {
    case unsupported
    case failed
}

protocol AIService {
    func summarize(title: String, body: String) async throws -> AISummary
    func answer(question: String, context: String) async throws -> String
}

