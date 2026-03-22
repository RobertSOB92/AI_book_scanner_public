import Foundation
import GoogleGenerativeAI

final class GeminiAIService: AIContentServiceProtocol {
    private let settingsService: SettingsServiceProtocol

    init(settingsService: SettingsServiceProtocol) {
        self.settingsService = settingsService
    }

    func identifyAndDescribe(rawText: String, allowedDomains: [String]) async throws -> BookResult {
        let apiKey = settingsService.geminiApiKey
        guard !apiKey.isEmpty else {
            throw AppError.missingGeminiApiKey
        }

        let model = GenerativeModel(name: "gemini-2.5-flash", apiKey: apiKey)

        let prompt = """
        Identify the book from this raw OCR text: "\(rawText)".
        Find a summary looking specifically at these domains if possible: \(allowedDomains.joined(separator: ", ")).
        STRICTLY RETURN JSON ONLY. No markdown formatting.
        JSON Format: {"title": "String", "author": "String", "description": "String (In Polish)", "sourceUrl": "String"}
        """

        do {
            let response = try await model.generateContent(prompt)

            guard let text = response.text else {
                throw URLError(.badServerResponse)
            }

            let cleanText = text.replacingOccurrences(of: "```json", with: "")
                .replacingOccurrences(of: "```", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)

            guard let data = cleanText.data(using: .utf8) else {
                throw URLError(.cannotDecodeContentData)
            }

            return try JSONDecoder().decode(BookResult.self, from: data)
        } catch {
            print("Błąd Gemini: \(error)")
            throw error
        }
    }
}
