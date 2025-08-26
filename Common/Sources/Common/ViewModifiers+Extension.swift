//    
//  ViewModifiers+Extension.swift
//  Common
//

import SwiftUI

struct SectionTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .padding(.top, 8)
    }
}

struct PrimaryButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .cornerRadius(12)
            .shadow(radius: 2)
    }
}

struct SecondaryButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .font(.subheadline)
            .foregroundColor(.white)
            .padding()
            .background(Color.gray)
            .cornerRadius(8)
            .shadow(radius: 2)
    }
}

struct InputField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
    }
}

struct ClearButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .foregroundColor(.white)
            .padding(8)
            .background(Color.red)
            .cornerRadius(8)
            .shadow(radius: 2)
    }
}

struct FilterChipStyle: ViewModifier {
    let isActive: Bool

    func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            .background(
                isActive ?
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6)) : nil
            )
            .overlay(
                isActive ?
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1) : nil
            )
    }
}

struct OverlayCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: 350)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 20)
            .transition(.move(edge: .bottom))
            .animation(.spring(), value: true)
    }
}

struct ListRowCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listRowBackground(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    .padding(.vertical, 4)
            )
            .padding(.vertical, 4)
    }
}

// MARK: - Public Extensions
public extension View {
    func sectionTitle() -> some View { modifier(SectionTitle()) }
    func primaryButton() -> some View { modifier(PrimaryButton()) }
    func secondaryButton() -> some View { modifier(SecondaryButton()) }
    func inputField() -> some View { modifier(InputField()) }
    func clearButton() -> some View { modifier(ClearButtonStyle()) }
    func filterChip(isActive: Bool) -> some View { modifier(FilterChipStyle(isActive: isActive)) }
    func overlayCard() -> some View { modifier(OverlayCardStyle()) }
    func listRowCard() -> some View { modifier(ListRowCardStyle()) }
}
