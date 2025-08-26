//    
//  FridgeItemModel.swift
//  HYLASTIX Fridge
//

import Foundation
import CoreData

struct FridgeItemModel: Codable, Identifiable {
    let id: String
    let name: String
    var timeStored: Date
    var bestBeforeDate: Date
    var type: FridgeItemType
}

struct FridgeItemType: Codable, Identifiable {
    let id: String
    var name: String
}

extension FridgeItemType {
    func toDomain(context: NSManagedObjectContext) -> FridgeItemTypeEntity {
        let entity = FridgeItemTypeEntity(context: context)
        entity.id = id
        entity.name = name
        return entity
    }
}

extension FridgeItemModel {
    func toDomain(context: NSManagedObjectContext) -> FridgeItemEntity {
        let entity = FridgeItemEntity(context: context)
        entity.id = id
        entity.name = name
        entity.timeStored = timeStored
        entity.bestBeforeDate = bestBeforeDate
        entity.type = type.toDomain(context: context)
        return entity
    }
}
