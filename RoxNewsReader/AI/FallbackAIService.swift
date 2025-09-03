//
//  FallbackAIService.swift
//  RoxNewsReader
//
//  Created by Avanish Samala on 9/2/25.
//


import Foundation
import NaturalLanguage

import Foundation

final class FallbackAIService: AIService {
    func summarize(title: String, body: String) async throws -> AISummary {
        throw AIError.unsupported
    }

    func answer(question: String, context: String) async throws -> String {
        throw AIError.unsupported
    }
}
