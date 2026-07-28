import Foundation

enum AppConfig {
    private static let filename = "config"

    private enum Keys {
        static let apiBaseURL = "API_BASE_URL"
        static let apiToken = "API_TOKEN"
    }

    private static let fallbackConfig: [String: Any] = [
        Keys.apiBaseURL: "https://api.github.com",
        Keys.apiToken: ""
    ]

    private static var config: [String: Any] {
        guard
            let url = Bundle.main.url(forResource: filename, withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil),
            let dict = plist as? [String: Any]
        else {
            return fallbackConfig
        }

        return dict.merging(fallbackConfig) { _, new in new }
    }

    static var apiBaseURL: String {
        config[Keys.apiBaseURL] as? String ?? "https://api.github.com"
    }

    static var apiToken: String {
        config[Keys.apiToken] as? String ?? ""
    }
}
