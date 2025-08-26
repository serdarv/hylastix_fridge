//    
//  ControllerAssembly.swift
//  HYLASTIX Fridge
//

import Foundation
import Swinject

class ControllerAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(FridgeServiceProtocol.self) { _ in
            return FridgeService()
        }
        .inObjectScope(.container)
    }
}
