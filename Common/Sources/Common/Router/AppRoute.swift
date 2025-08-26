//    
//  AppRoute.swift
//  Common
//

import SwiftUI

public protocol AppRoute: Hashable, Identifiable {
    func navigateTo() -> AnyView
}

public extension AppRoute {
    var id: String {
        UUID().uuidString
    }

    var isRoot: Bool {
        false
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func equal(_ other: any AppRoute) -> Bool {
        id == other.id
    }
}
