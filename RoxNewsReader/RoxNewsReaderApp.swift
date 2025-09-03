//
//  RoxNewsReaderApp.swift
//  RoxNewsReader
//
//  Created by Avanish Samala on 9/2/25.
//

import SwiftUI

@main
struct RoxReaderApp: App {
    @StateObject private var bookmarks = BookmarkStore()
    private let ai: AIService = AIResolver.make()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bookmarks)
                .preferredColorScheme(.dark)
        }
    }
}
