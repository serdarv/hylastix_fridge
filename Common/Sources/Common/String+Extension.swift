//    
//  String+Extension.swift
//  Common
//

import Foundation

public extension String {
    var localized: String {
        String(localized: String.LocalizationValue(self))
    }
}
