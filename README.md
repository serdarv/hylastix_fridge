# Hylastix Fridge

An iOS app to manage your fridge inventory efficiently, track expiration dates, and organize groceries by type. Built with **SwiftUI**, **Core Data**, and **MVVM architecture**.

---

## Features

- Add, remove, and edit groceries in your fridge
- Track **best before dates** to prevent food waste
- Organize items by **type** (e.g., Fruit, Dairy)
- Filter and search groceries by **name**, **quantity**, or **expiration**
- Visualize storage capacity with a **segmented storage bar**
- Swipe-to-delete for quick removal of items
- Persistent storage using **Core Data**
- Intuitive **sheet input forms** with autocomplete suggestions

---

## Usage

- Tap + to add a new grocery with a type and expiration date.
- Tap an item to view details.
- Swipe an item to delete it.
- Use the filter button to search by name.
- Press Clear Storage to remove all expired items.

---

## Architecture

 - MVVM: Separate views, view models, and repositories.
 - Dependency Injection: Managed with Swinject.
 - Core Data: Stores FridgeItemEntity and FridgeItemTypeEntity.

---

## Dependencies

Swinject
 – Dependency injection
SwiftUI
 – UI framework
Core Data 
 – Local persistence

---

## Installation

1. Clone the repository:

```bash
git clone https://github.com/serdarv/hylastix_fridge.git
cd hylastix_fridge
open HylastixFridge.xcodeproj
Build and run on a simulator
