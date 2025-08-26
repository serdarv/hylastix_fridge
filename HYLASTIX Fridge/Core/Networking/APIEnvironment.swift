//    
//  APIEnvironment.swift
//  HYLASTIX Fridge
//

import Foundation

struct APIEnvironment {
    enum InfoPlistKeys: String {
        case baseURL = "BASE_URL"
    }

    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    /// The default HTTP request headers for the given environment.
    static var headers: ReaquestHeaders? {
        return [
            "Content-Type" : "application/json",
        ]
    }

    private static func getValue(for key: InfoPlistKeys) -> String {
        guard let value = infoDictionary[key.rawValue] as? String else {
            fatalError("\(key.rawValue) not set in plist")
        }
        return value
    }

    // MARK: - Plist values

    /// The base URL of the given environment.
    static var baseURL: String {
        getValue(for: .baseURL)
    }
}
