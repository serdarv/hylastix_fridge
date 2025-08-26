//    
//  DateFormatter+Extension.swift
//  Common
//

import Foundation

public extension DateFormatter {
    /// Create custom date formatter
    static let custom: DateFormatter = {
        let formatter = DateFormatter()
        return formatter
    }()
}
