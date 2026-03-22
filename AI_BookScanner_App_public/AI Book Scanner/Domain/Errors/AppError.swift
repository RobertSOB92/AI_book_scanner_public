import Foundation

enum AppError: LocalizedError {
    case ocrFailed
    case aiProcessingFailed(String)
    case invalidResponseFormat
    case noData
    case missingGeminiApiKey

    var errorDescription: String? {
        switch self {
        case .ocrFailed: return "Nie udało się odczytać tekstu ze zdjęcia."
        case .aiProcessingFailed(let msg): return "Błąd AI: \(msg)"
        case .invalidResponseFormat: return "Otrzymano nieprawidłowy format danych."
        case .noData: return "Brak danych."
        case .missingGeminiApiKey: return "Dodaj klucz Gemini API w ustawieniach, aby korzystać z AI."
        }
    }
}
