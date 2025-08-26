//
//  FridgeItemEntity.swift
//  HYLASTIX Fridge
//

import CoreData

@objc(FridgeItemEntity)
public class FridgeItemEntity: NSManagedObject, Identifiable {
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var timeStored: Date
    @NSManaged public var bestBeforeDate: Date
    @NSManaged public var type: FridgeItemTypeEntity
}

extension FridgeItemEntity {
    func toModel() -> FridgeItemModel {
        FridgeItemModel(id: id,
                        name: name,
                        timeStored: timeStored,
                        bestBeforeDate: bestBeforeDate,
                        type: type.toModel())
    }
}

extension FridgeItemEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FridgeItemEntity> {
        return NSFetchRequest<FridgeItemEntity>(entityName: "FridgeItemEntity")
    }
}
