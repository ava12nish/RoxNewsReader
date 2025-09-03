//
//  AIResolver.swift
//  RoxNewsReader
//
//  Created by Avanish Samala on 9/2/25.
//


import Foundation

enum AIResolver {
    static func make() -> AIService {
        #if canImport(FoundationModels)
        if #available(iOS 26.0, macOS 15.0, *) {
            return AppleAIService()
        }
        #endif
        return FallbackAIService()
    }
}
