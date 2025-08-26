//    
//  AppRouter.swift
//  Common
//

import SwiftUI

public class AppRouter: ObservableObject {

    public init(rootRoute: (any AppRoute)? = nil, selectionPath: NavigationPath = NavigationPath()) {
        self.rootRoute = rootRoute
        self.selectionPath = selectionPath
    }

    private(set) var rootRoute: (any AppRoute)?
    @Published public var selectionPath = NavigationPath()
}

public extension AppRouter {
    func addToRoute(_ route: any AppRoute) {
        if route.isRoot {
            if rootRoute?.equal(route) == true {
                popToRoot()
            } else {
                replaceRootRoute(route)
            }
        } else {
            if selectionPath.count == 0 {
                rootRoute = route
            }
            selectionPath.append(route)
        }
    }

    func replaceRoute(_ route: any AppRoute, _ count: Int = 1) {
        selectionPath.removeLast(count)
        if selectionPath.count == 0 {
            rootRoute = route
        }
        selectionPath.append(route)
    }

    func navigateTo(_ route: any AppRoute) -> AnyView {
        route.navigateTo()
    }

    func popToRoot() {
        selectionPath.removeLast(selectionPath.count - 1)
    }

    func popBack() {
        selectionPath.removeLast()
    }

    func replaceRootRoute(_ route: any AppRoute) {
        selectionPath.removeLast(selectionPath.count)
        selectionPath.append(route)
        rootRoute = route
    }
}
