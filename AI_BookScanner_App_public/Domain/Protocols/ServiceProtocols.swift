import UIKit

protocol OCRServiceProtocol: Sendable {
    func extractText(from image: UIImage) async throws -> String
}

protocol AIContentServiceProtocol: Sendable {
    func identifyAndDescribe(rawText: String, allowedDomains: [String]) async throws -> BookResult
}

protocol SettingsServiceProtocol: Sendable {
    var prefixText: String { get set }
    var targetDomains: [String] { get set }
}
