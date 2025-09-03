//
//  AIServiceKey.swift
//  RoxNewsReader
//
//  Created by Avanish Samala on 9/2/25.
//


import SwiftUI

private struct AIServiceKey: EnvironmentKey {
    static let defaultValue: AIService = FallbackAIService()
}

extension EnvironmentValues {
    var aiService: AIService {
        get { self[AIServiceKey.self] }
        set { self[AIServiceKey.self] = newValue }
    }
}
