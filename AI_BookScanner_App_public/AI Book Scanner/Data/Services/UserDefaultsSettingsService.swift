import Foundation

final class UserDefaultsSettingsService: SettingsServiceProtocol, @unchecked Sendable {
    private let defaults = UserDefaults.standard
    private let prefixKey = "user_prefix_text"
    private let domainsKey = "user_target_domains"
    private let geminiApiKeyKey = "user_gemini_api_key"

    var prefixText: String {
        get { defaults.string(forKey: prefixKey) ?? "" }
        set { defaults.set(newValue, forKey: prefixKey) }
    }

    var targetDomains: [String] {
        get { defaults.stringArray(forKey: domainsKey) ?? ["lubimyczytac.pl", "empik.com"] }
        set { defaults.set(newValue, forKey: domainsKey) }
    }

    var geminiApiKey: String {
        get { (defaults.string(forKey: geminiApiKeyKey) ?? "").trimmingCharacters(in: .whitespacesAndNewlines) }
        set { defaults.set(newValue.trimmingCharacters(in: .whitespacesAndNewlines), forKey: geminiApiKeyKey) }
    }
}
