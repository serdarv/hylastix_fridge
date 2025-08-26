//
//  AddGrocerySheet.swift
//  HYLASTIX Fridge
//

import SwiftUI
import Common

struct AddGrocerySheet: View {
    @Binding var show: Bool
    var allTypes: [FridgeItemType]
    @State private var groceryType: String = ""
    @State private var groceryName: String = ""
    @State private var selectedDate: Date = Date()
    var onAdd: (String, String, Date) -> Void

    var filteredSuggestions: [String] {
        guard !groceryType.isEmpty else { return [] }
        return allTypes.map { $0.name }.filter {
            $0.lowercased().contains(groceryType.lowercased()) &&
            $0.lowercased() != groceryType.lowercased()
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ZStack {
                LinearGradient(
                    colors: [Color.green.opacity(0.8), Color.green.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 60)
                .cornerRadius(12, corners: [.topLeft, .topRight])
                .shadow(radius: 3)

                Text("Add New Grocery")
                    .font(.headline)
                    .foregroundColor(.white)
            }

            Text("Grocery name")
                .sectionTitle()
                .padding(.horizontal)

            TextField("Enter grocery name", text: $groceryName)
                .inputField()
                .padding(.horizontal)

            ZStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Grocery type")
                        .sectionTitle()

                    TextField("Enter grocery type", text: $groceryType)
                        .inputField()

                    Text("Expiration date")
                        .sectionTitle()

                    HStack {
                        Spacer()
                        DatePicker(
                            "",
                            selection: $selectedDate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        Spacer()
                    }
                    Spacer()
                }

                VStack {
                    if !filteredSuggestions.isEmpty {
                        VStack(spacing: 0) {
                            ForEach(filteredSuggestions, id: \.self) { suggestion in
                                Text(suggestion)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .onTapGesture { groceryType = suggestion }
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(uiColor: .secondarySystemBackground))
                                .shadow(radius: 4)
                        )
                        .frame(maxHeight: 150)
                        .padding(.horizontal)
                        .padding(.top, 30)
                        .zIndex(1)
                    }
                    Spacer()
                }
            }
            .padding()

            Button("Add") {
                onAdd(groceryName, groceryType, selectedDate)
                groceryType = ""
                groceryName = ""
                show = false
            }
            .primaryButton()
            .disabled(groceryName.isEmpty || groceryType.isEmpty)

            Button("Cancel") { show = false }
                .secondaryButton()

            Spacer()
        }
        .presentationDetents([.large])
        .background(Color(.systemBackground).ignoresSafeArea(edges: .bottom))
    }
}
