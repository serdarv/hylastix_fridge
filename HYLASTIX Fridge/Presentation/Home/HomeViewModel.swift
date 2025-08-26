//    
//  HomeViewModel.swift
//  HYLASTIX Fridge
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {

    typealias GroupedItem = (key: String, value: [FridgeItemModel])

    // MARK: - Dependency injection
    private let fridgeController: FridgeServiceProtocol

    // MARK: - Published variables
    @Published var items: [FridgeItemModel] = [] {
        didSet {
            filteredItems = items
        }
    }
    @Published var showClearStorageWarning: Bool = false
    @Published var showAddNew: Bool = false
    @Published var showFilterOverlay = false
    @Published var filterName = ""
    @Published var types: [FridgeItemType] = []

    public var itemsCount: Int {
        items.count
    }

    public var filteredItems: [FridgeItemModel] = []
    var isStorageFull: Bool {
        items.count >= Settings.storageCapacity
    }

    // MARK: - init
    init(fridgeController: FridgeServiceProtocol = DIManager.shared.resolve(FridgeServiceProtocol.self)) {
        self.fridgeController = fridgeController
    }

    // MARK: - Functions
    func getFridgeItems() async {
            do {
                let fetchedItems = try await fridgeController.getFridgeItems() ?? []
                await MainActor.run {
                    items = fetchedItems
                    types = fridgeController.getTypes()
                }
            } catch {
                debugPrint(error.localizedDescription)
            }
    }

    func filterItems() {
        guard !filterName.isEmpty else {
            filteredItems = items
            return
        }
        filteredItems = items.filter { $0.name.lowercased().contains(filterName.lowercased()) }
    }

    func addNewGrocery(name: String, type: String, expirationDate: Date) {
        let type = fridgeController.addType(name: type)
        fridgeController.addNewGrocery(name: name,
                                       bestBeforeDate: expirationDate,
                                       type: type)
        Task {
            await getFridgeItems()
        }
    }

    func deleteGrocery(id: String) {
        fridgeController.removeGrocery(id: id)
        Task {
            await getFridgeItems()
        }
    }

    func removeAllExpired() {
        fridgeController.removeAllExpired()
        Task {
            await getFridgeItems()
        }
    }

    func groupedItems() -> [GroupedItem] {
        let groupedDict = Dictionary(grouping: filteredItems, by: { $0.type.name })

        return types.compactMap { type in
            guard let itemsOfType = groupedDict[type.name], !itemsOfType.isEmpty else {
                return nil
            }
            return GroupedItem(type.name, itemsOfType)
        }
    }
}
