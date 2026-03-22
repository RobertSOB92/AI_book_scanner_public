import Foundation

final class UserDefaultsSettingsService: SettingsServiceProtocol, @unchecked Sendable {
    private let defaults = UserDefaults.standard
    private let prefixKey = "user_prefix_text"
    private let domainsKey = "user_target_domains"
    
    var prefixText: String {
        get { defaults.string(forKey: prefixKey) ?? "" }
        set { defaults.set(newValue, forKey: prefixKey) }
    }
    
    var targetDomains: [String] {
        get { defaults.stringArray(forKey: domainsKey) ?? ["lubimyczytac.pl", "empik.com"] }
        set { defaults.set(newValue, forKey: domainsKey) }
    }
}
