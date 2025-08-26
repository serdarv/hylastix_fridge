//    
//  HYLASTIX_FridgeApp.swift
//  HYLASTIX Fridge
//

import SwiftUI
import Common

@main
struct HYLASTIX_FridgeApp: App {
    @StateObject private var router = AppRouter()

    init() {
        DIManager.shared.setup()
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.selectionPath) {
                HomeView()
                    .navigationDestination(for: HomeRoute.self ) { path in
                        router.navigateTo(path)
                    }
            }
            .environment(\.colorScheme, .light)
            .environmentObject(router)
        }
    }
}
