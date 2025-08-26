//
//  CoreDataProviding.swift
//  HYLASTIX Fridge
//

import CoreData

protocol CoreDataProviding {
    var context: NSManagedObjectContext { get }
    func saveContext()
    var onLoaded: (() -> Void)? { get set }
}

final class CoreDataProvider: CoreDataProviding {
    static let shared = CoreDataProvider()
    let persistentContainer: NSPersistentContainer
    var onLoaded: (() -> Void)?

    init() {
        persistentContainer = NSPersistentContainer(name: "FridgeCoreModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error { fatalError("Core Data error: \(error)") }
            print("Core Data loaded")
            self.onLoaded?()
        }
    }

    var context: NSManagedObjectContext { persistentContainer.viewContext }

    func saveContext() {
        guard context.hasChanges else { return }
        try? context.save()
    }
}
