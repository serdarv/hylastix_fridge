//    
//  HomeRoute.swift
//  HYLASTIX Fridge
//

import Common
import SwiftUI

enum HomeRoute: AppRoute {

    case home

    func navigateTo() -> AnyView {
        switch self {
        case .home:
            AnyView(HomeView())
        }
    }

    static func == (lhs: HomeRoute, rhs: HomeRoute) -> Bool {
        lhs.id == rhs.id
    }
}
