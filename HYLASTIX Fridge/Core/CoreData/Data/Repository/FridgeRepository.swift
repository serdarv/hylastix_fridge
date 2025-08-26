//
//  FridgeRepository.swift
//  HYLASTIX Fridge
//

import CoreData

protocol FridgeItemRepository {
    func create(name: String, bestBeforeDate: Date, type: FridgeItemTypeEntity) -> FridgeItemEntity
    func getAll() -> [FridgeItemEntity]
    func get(byID id: String) -> FridgeItemEntity?
    func update(item: FridgeItemEntity, name: String?)
    func delete(item: FridgeItemEntity)
    func removeAllExpired()
}

final class FridgeItemRepositoryImpl: FridgeItemRepository {
    private let coreData: CoreDataProviding

    init(coreData: CoreDataProviding) {
        self.coreData = coreData
    }

    private var context: NSManagedObjectContext {
        coreData.context
    }

    func create(name: String, bestBeforeDate: Date, type: FridgeItemTypeEntity) -> FridgeItemEntity {
        let item = FridgeItemEntity(context: context)
        item.id = UUID().uuidString
        item.name = name
        item.bestBeforeDate = bestBeforeDate
        item.timeStored = Date()
        item.type = type
        saveContext()
        return item
    }

    func getAll() -> [FridgeItemEntity] {
        let request: NSFetchRequest<FridgeItemEntity> = FridgeItemEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }

    func get(byID id: String) -> FridgeItemEntity? {
        let request: NSFetchRequest<FridgeItemEntity> = FridgeItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }

    func update(item: FridgeItemEntity, name: String?) {
        if let name = name { item.name = name }
        saveContext()
    }

    func delete(item: FridgeItemEntity) {
        context.delete(item)
        saveContext()
    }

    func removeAllExpired() {
        let request: NSFetchRequest<FridgeItemEntity> = FridgeItemEntity.fetchRequest()

        do {
            let fridgeItems = try context.fetch(request)

            let expiredDetails = fridgeItems.filter { $0.bestBeforeDate < Date() }

            for detail in expiredDetails {
                context.delete(detail)
            }

            try context.save()
            print("All expired ItemDetails deleted.")
        } catch {
            print("Failed to delete expired items: \(error)")
        }
    }

    private func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Save error: \(error)")
        }
    }
}
