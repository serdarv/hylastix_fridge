//
//  ItemView.swift
//  HYLASTIX Fridge
//

import SwiftUI
import Common

struct ItemView: View {

    // Date formatter for displaying dates nicely
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }

    var item: FridgeItemModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(item.name)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                VStack {
                    Text("Best Before: \(item.bestBeforeDate.toString().formatDate())")
                        .font(.subheadline)
                        .foregroundColor((item.bestBeforeDate) < Date() ? .red : .green)
                    Text("Time Stored: \(item.timeStored.toString().formatDate())")
                        .font(.subheadline)
                }
            }

        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
