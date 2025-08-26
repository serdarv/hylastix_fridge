//    
//  Date+Extension.swift
//  Common
//

import Foundation

public extension Date {
    func toString() -> String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
}

public extension String {
    func toDate() -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: self)
    }

    func formatDate() -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]
        guard let date = isoFormatter.date(from: self) else {
            fatalError("Invalid ISO date string")
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}
