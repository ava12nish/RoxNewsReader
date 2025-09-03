//
//  DateFormats.swift
//  RoxNewsReader
//
//  Created by Avanish Samala on 9/2/25.
//


import Foundation

enum DateFormats {
    static let api: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()

    static let display: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }()

    static func displayString(from date: Date?) -> String {
        guard let date else { return "—" }
        return display.string(from: date)
    }
}
