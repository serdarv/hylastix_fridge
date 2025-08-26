//    
//  FridgeItemTypeRepository.swift
//  HYLASTIX Fridge
//

import CoreData

protocol FridgeItemTypeRepository {
    func create(name: String) -> FridgeItemTypeEntity
    func getAll() -> [FridgeItemTypeEntity]
    func get(byID id: String) -> FridgeItemTypeEntity?
    func delete(item: FridgeItemTypeEntity)
}

final class FridgeItemTypeRepositoryImpl: FridgeItemTypeRepository {
    private let coreData: CoreDataProviding

    init(coreData: CoreDataProviding) {
        self.coreData = coreData
    }

    private var context: NSManagedObjectContext {
        coreData.context
    }

    func create(name: String) -> FridgeItemTypeEntity {
        let request: NSFetchRequest<FridgeItemTypeEntity> = FridgeItemTypeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        request.fetchLimit = 1

        if let existing = try? context.fetch(request).first {
            return existing
        }

        let newType = FridgeItemTypeEntity(context: context)
        newType.id = UUID().uuidString
        newType.name = name
        return newType
    }

    func getAll() -> [FridgeItemTypeEntity] {
        let request: NSFetchRequest<FridgeItemTypeEntity> = FridgeItemTypeEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }

    func get(byID id: String) -> FridgeItemTypeEntity? {
        let request: NSFetchRequest<FridgeItemTypeEntity> = FridgeItemTypeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }

    func delete(item: FridgeItemTypeEntity) {
        context.delete(item)
        saveContext()
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
