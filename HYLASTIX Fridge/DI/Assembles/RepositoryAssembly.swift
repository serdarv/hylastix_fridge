//    
//  RepositoryAssembly.swift
//  HYLASTIX Fridge
//

import Foundation
import Swinject

class RepositoryAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(CoreDataProviding.self) { _ in
            return CoreDataProvider()
        }
        .inObjectScope(.container)

        container.register(FridgeItemRepository.self) { resolver in
            let coreData = resolver.resolve(CoreDataProviding.self)!
            return FridgeItemRepositoryImpl(coreData: coreData)
        }
        .inObjectScope(.container)

        container.register(FridgeItemTypeRepository.self) { resolver in
            let coreData = resolver.resolve(CoreDataProviding.self)!
            return FridgeItemTypeRepositoryImpl(coreData: coreData)
        }
        .inObjectScope(.container)
    }
}
