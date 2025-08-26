//
//  FridgeService.swift
//  HYLASTIX Fridge
//

import Foundation
import CoreData
import SwiftUICore

protocol FridgeServiceProtocol {
    func getFridgeItems() async throws -> [FridgeItemModel]?
    func addNewGrocery(name: String, bestBeforeDate: Date, type: FridgeItemTypeEntity)
    func removeGrocery(id: String)
    func removeAllExpired()
    func getTypes() -> [FridgeItemType]
    func addType(name: String) -> FridgeItemTypeEntity
}

class FridgeService: FridgeServiceProtocol {
    let fridgeRepo = DIManager.shared.resolve(FridgeItemRepository.self)
    let fridgeTypeRepo = DIManager.shared.resolve(FridgeItemTypeRepository.self)

    func getFridgeItems() async throws -> [FridgeItemModel]? {
        // This is what request is suposed to look like in real life usecase
        //        let request = FridgeEndpoint<[FridgeItemModel]>.getFrigdeItems
        //        let operation = APIOperation(request)
        //        let result = try await operation.execute(in: APIRequestDispatcher.shared)
        //
        //        switch result {
        //        case .json(let response):
        //            return response
        //        case .error(let error):
        //            throw error
        //        }
        return fridgeRepo.getAll().map({ $0.toModel() })
    }

    func addNewGrocery(name: String, bestBeforeDate: Date, type: FridgeItemTypeEntity) {
        _ = fridgeRepo.create(name: name, bestBeforeDate: bestBeforeDate, type: type)
    }

    func removeGrocery(id: String) {
        if let grocery = fridgeRepo.get(byID: id) {
            fridgeRepo.delete(item: grocery)
        }
    }

    func addType(name: String) -> FridgeItemTypeEntity {
        fridgeTypeRepo.create(name: name)
    }

    func getTypes() -> [FridgeItemType] {
        fridgeTypeRepo.getAll().map({ $0.toModel() })
    }

    func removeAllExpired() {
        fridgeRepo.removeAllExpired()
    }
}
