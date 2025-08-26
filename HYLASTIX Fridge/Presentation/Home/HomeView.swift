//
//  HomeView.swift
//  HYLASTIX Fridge
//

import SwiftUI
import Common

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    @EnvironmentObject var router: AppRouter

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.purple.opacity(0.1), Color.blue.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Storage capacity \(viewModel.itemsCount) / \(Settings.storageCapacity)")
                            .font(.subheadline)
                            .foregroundColor(.primary)

                        SegmentedStorageBar(
                            used: Double(viewModel.itemsCount),
                            total: Double(Settings.storageCapacity)
                        )
                        .frame(height: 16)
                    }
                    Spacer()
                    Button {
                        viewModel.showClearStorageWarning = true
                    } label: {
                        Text("Clear storage").clearButton()
                    }
                }
                .padding(.horizontal)

                HStack(spacing: 20) {
                    Spacer()
                    HStack {
                        if !viewModel.filterName.isEmpty {
                            Text(viewModel.filterName)
                                .font(.subheadline)
                            Button {
                                viewModel.filterName = ""
                                viewModel.filterItems()
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                        Button {
                            viewModel.showFilterOverlay = true
                        } label: {
                            Image(systemName: "line.horizontal.3.decrease.circle")
                                .font(.largeTitle)
                                .foregroundColor(.green)
                        }
                    }
                    .filterChip(isActive: !viewModel.filterName.isEmpty)

                    Button {
                        viewModel.showAddNew = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(viewModel.isStorageFull ? .gray : .green)
                            .shadow(radius: 2)
                    }
                    .disabled(viewModel.isStorageFull)
                }
                .padding(.horizontal)

                List {
                    ForEach(viewModel.groupedItems(), id: \.key) { group in
                        Section(header: Text(group.key).sectionTitle()) {
                            ForEach(group.value, id: \.id) { item in
                                ItemView(item: item)
                                    .listRowCard()
                            }
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let idToDelete = viewModel.items[index].id
                            viewModel.deleteGrocery(id: idToDelete)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .task {
                    await viewModel.getFridgeItems()
                }
            }
            .padding(.vertical)
        }
        .overlay {
            if viewModel.showFilterOverlay {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture { withAnimation { viewModel.showFilterOverlay = false } }

                    VStack(spacing: 16) {
                        Text("Filter by name").sectionTitle()

                        TextField("Enter name", text: $viewModel.filterName)
                            .inputField()
                            .padding(.horizontal)

                        Button {
                            withAnimation {
                                viewModel.filterItems()
                                viewModel.showFilterOverlay = false
                            }
                        } label: {
                            Text("Done").primaryButton()
                        }
                    }
                    .overlayCard()
                }
            }
        }
        .sheet(isPresented: $viewModel.showAddNew) {
            AddGrocerySheet(
                show: $viewModel.showAddNew,
                allTypes: viewModel.types,
                onAdd: { name, type, expirationDate in
                    viewModel.addNewGrocery(name: name, type: type, expirationDate: expirationDate)
                }
            )
        }
        .alert("CLEAR STORAGE", isPresented: $viewModel.showClearStorageWarning, actions: {
            HStack {
                Button("Clear") {
                    viewModel.removeAllExpired()
                    viewModel.showClearStorageWarning = false
                }
                Button("Cancel") {
                    viewModel.showClearStorageWarning = false
                }
            }
        }, message: {
            Text("Do you want to clear expired items?")
        })
    }
}

#Preview {
    HomeView()
}
