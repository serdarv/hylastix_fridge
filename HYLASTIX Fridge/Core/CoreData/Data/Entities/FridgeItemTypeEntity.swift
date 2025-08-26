//    
//  FridgeItemTypeEntity.swift
//  HYLASTIX Fridge
//

import CoreData
import Foundation

@objc(FridgeItemTypeEntity)
public class FridgeItemTypeEntity: NSManagedObject, Identifiable {
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var items: NSSet?
}

extension FridgeItemTypeEntity {
    func toModel() -> FridgeItemType {
        FridgeItemType(id: id, name: name)
    }
}

extension FridgeItemTypeEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FridgeItemTypeEntity> {
        return NSFetchRequest<FridgeItemTypeEntity>(entityName: "FridgeItemTypeEntity")
    }
}
