//
//  RoxTheme.swift
//  RoxNewsReader
//
//  Created by Avanish Samala on 9/2/25.
//

import SwiftUI

enum Rox {
    // Brand colors (tweak to taste)
    static let accent      = Color(hex: 0xF5C542)          // warm gold glow
    static let accentDim   = Color(hex: 0xC49F2A)
    static let bg          = Color(hex: 0x0E0E10)          // app background
    static let surface     = Color(hex: 0x141417)          // list background
    static let card        = Color(hex: 0x191A1F)          // card surface
    static let stroke      = Color.white.opacity(0.06)
    static let textPrimary = Color.white
    static let textMuted   = Color.white.opacity(0.66)
    static let chip        = Color.white.opacity(0.08)

    static let glow = LinearGradient(
        colors: [accent.opacity(0.45), .clear],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )

    // Typography
    struct Font {
        static let title    = SwiftUI.Font.system(.title3, design: .rounded).weight(.semibold)
        static let subtitle = SwiftUI.Font.system(.footnote, design: .rounded).weight(.regular)
        static let body     = SwiftUI.Font.system(.callout, design: .rounded)
        static let mono     = SwiftUI.Font.system(.caption, design: .monospaced)
    }
}

// MARK: - Helpers
extension Color {
    init(hex: UInt32, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}

struct RoxCard: ViewModifier {
    var padded: Bool = true
    func body(content: Content) -> some View {
        content
            .padding(padded ? 14 : 0)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Rox.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Rox.stroke, lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.35), radius: 16, x: 0, y: 8)
    }
}

extension View {
    func roxCard(padded: Bool = true) -> some View { modifier(RoxCard(padded: padded)) }
    func roxSeparator() -> some View {
        Rectangle().fill(Rox.stroke).frame(height: 1).opacity(0.9)
    }
}

struct RoxPill: View {
    let text: String
    var icon: String? = nil
    var body: some View {
        HStack(spacing: 6) {
            if let icon { Image(systemName: icon).imageScale(.small) }
            Text(text)
        }
        .font(.caption2)
        .foregroundStyle(Rox.textMuted)
        .padding(.horizontal, 8).padding(.vertical, 4)
        .background(Capsule(style: .continuous).fill(Rox.chip))
    }
}

struct RoxPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.callout.weight(.semibold))
            .foregroundStyle(.black)
            .padding(.horizontal, 14).padding(.vertical, 10)
            .background(
                Capsule().fill(Rox.accent)
                    .overlay(Capsule().stroke(Rox.accentDim, lineWidth: 1))
                    .shadow(color: Rox.accent.opacity(configuration.isPressed ? 0.1 : 0.35),
                            radius: configuration.isPressed ? 3 : 10, y: 6)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}
