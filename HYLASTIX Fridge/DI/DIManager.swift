//    
//  DIManager.swift
//  HYLASTIX Fridge
//

import Foundation
import Swinject

final class DIManager {
    enum Service {
        case controllerService
        case repositoryService

        var assembly: Assembly {
            switch self {
            case .controllerService:
                return ControllerAssembly()
            case .repositoryService:
                return RepositoryAssembly()
            }
        }

        static let allCasess: [Service] = [.repositoryService, .controllerService]
    }

    static let shared = DIManager()
    private(set) var container: Container!
    private var assembler: Assembler!
    private var synchronizedResolver: Resolver!

    func setup() {
        container = Container()
        assembler = Assembler(Service.allCasess.map { $0.assembly }, container: container)
        let resolver = assembler.resolver as? Container
        synchronizedResolver = resolver?.synchronize()
    }

    func resolve<Service>(_ serviceType: Service.Type) -> Service {
        guard let service = synchronizedResolver.resolve(serviceType) else {
            fatalError("Service \(serviceType) can't be resolved!")
        }
        return service
    }
}
