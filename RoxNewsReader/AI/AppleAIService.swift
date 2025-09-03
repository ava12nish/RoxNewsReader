//
//  AppleAIService.swift
//  RoxNewsReader
//

import Foundation

#if canImport(FoundationModels)
import FoundationModels
#endif

@available(iOS 26.0, macOS 15.0, *)
final class AppleAIService: AIService {

    // MARK: - Summarize
    func summarize(title: String, body: String) async throws -> AISummary {
        #if canImport(FoundationModels)
        let model = SystemLanguageModel()
        let instructions = Instructions("Summarize in one short paragraph (~3 sentences), then 3–5 bullets, then up to 5 tags.")
        let session = try LanguageModelSession(model: model, instructions: instructions)

        let promptText = """
        Title: \(title)

        Article:
        \(body)

        Return exactly in this layout:

        Paragraph:
        <3 short sentences>

        Bullets:
        - point one
        - point two
        - point three

        Tags:
        tag1, tag2, tag3
        """
        let prompt = Prompt(promptText)

        // NOTE: In this seed, `respond(to:)` returns a Response<String>, not String.
        // We normalize it to String below.
        let raw = try await session.respond(to: prompt)              // <- no options to avoid “extra argument” error
        let output = normalizeModelText(raw)

        let (paragraph, bullets, tags) = parseSummarySections(from: output)
        return AISummary(paragraph: paragraph, bullets: bullets, tags: tags)
        #else
        throw AIError.unsupported
        #endif
    }

    // MARK: - Q&A
    func answer(question: String, context: String) async throws -> String {
        #if canImport(FoundationModels)
        let model = SystemLanguageModel()
        let instructions = Instructions("""
        Answer in 2–4 sentences using only the provided article context.
        If not present, reply: "This article does not provide enough information."
        """)
        let session = try LanguageModelSession(model: model, instructions: instructions)

        let qPrompt = """
        ARTICLE:
        \(context)

        QUESTION:
        \(question)
        """
        let prompt = Prompt(qPrompt)

        // Same pattern here — get the response object, then normalize to text.
        let raw = try await session.respond(to: prompt)              // <- if your seed shows a different name, pick that via autocomplete
        return normalizeModelText(raw)
        #else
        throw AIError.unsupported
        #endif
    }
}

// MARK: - Helpers (pure Swift)

@available(iOS 26.0, macOS 15.0, *)
private func parseSummarySections(from output: String) -> (String, [String], [String]) {
    var paragraph = output.trimmingCharacters(in: .whitespacesAndNewlines)
    var bullets: [String] = []
    var tags: [String] = []

    if let r = output.range(of: "Paragraph:") {
        paragraph = String(output[r.upperBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    if let r = output.range(of: "Bullets:") {
        let after = output[r.upperBound...]
        bullets = after
            .components(separatedBy: CharacterSet.newlines)
            .map { String($0).trimmingCharacters(in: CharacterSet.whitespaces) }
            .filter { $0.hasPrefix("-") }
            .map { String($0.dropFirst()).trimmingCharacters(in: CharacterSet.whitespaces) }
    }
    if let r = output.range(of: "Tags:") {
        let after = output[r.upperBound...]
        tags = after
            .components(separatedBy: CharacterSet(charactersIn: ",\n"))
            .map { String($0).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
    return (paragraph, bullets, tags)
}

@available(iOS 26.0, macOS 15.0, *)
private func normalizeModelText(_ response: Any) -> String {
    // Many seeds return LanguageModelSession.Response<String>
    // Try common properties first; otherwise fallback to String(describing:).
    if let s = response as? String { return s }

    // Mirror to look for obvious text properties without tying to concrete types
    let mirror = Mirror(reflecting: response)
    for child in mirror.children {
        switch child.label {
        case "text", "output", "value", "string":
            if let v = child.value as? String { return v }
        default:
            if let v = child.value as? String { return v }
        }
    }
    // Some responses may wrap another response — one level of unwrap:
    if let only = mirror.children.first?.value {
        if let v = only as? String { return v }
        let innerMirror = Mirror(reflecting: only)
        for child in innerMirror.children {
            if let v = child.value as? String { return v }
        }
    }
    return String(describing: response)
}
