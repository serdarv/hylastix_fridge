//    
//  SegmentedStorageBar.swift
//  HYLASTIX Fridge
//

import SwiftUI

struct SegmentedStorageBar: View {
    var used: Double
    var total: Double

    var body: some View {
        GeometryReader { geo in
            let pct = total > 0 ? used / total : 0
            let width = geo.size.width * pct

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))

                RoundedRectangle(cornerRadius: 8)
                    .fill(color(for: pct))
                    .frame(width: width)
                    .animation(.easeInOut, value: pct)
            }
        }
        .frame(height: 12)
    }

    private func color(for pct: Double) -> Color {
        switch pct {
        case 0..<0.7: return .green
        case 0.7..<0.9: return .yellow
        default: return .red
        }
    }
}
