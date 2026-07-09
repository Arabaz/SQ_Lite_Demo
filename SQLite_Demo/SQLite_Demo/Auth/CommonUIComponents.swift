//
//  CommonUIComponents.swift
//  SQLite_Demo
//
//  Created by Apps WeLove on 07/07/26.
//

import SwiftUI

struct Theme {
    static let background = Color(red: 0.96, green: 0.97, blue: 0.99)       // Professional light slate off-white
    static let cardBackground = Color.white                                   // White cards/fields for contrast
    static let primaryText = Color(red: 0.09, green: 0.12, blue: 0.19)        // Sleek navy/charcoal for text
    static let secondaryText = Color(red: 0.38, green: 0.43, blue: 0.52)      // Soft slate grey for secondary text
    static let accent = Color(red: 0.14, green: 0.31, blue: 0.81)             // Professional royal blue for primary buttons/accents
    static let border = Color(red: 0.88, green: 0.90, blue: 0.94)             // Subtle gray border for textfields/cards
    static let success = Color(red: 0.10, green: 0.69, blue: 0.44)            // Emerald green for success screens
}

struct SignupHeaderView: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.largeTitle.bold())
                .foregroundStyle(Theme.primaryText)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(Theme.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Theme.accent)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}

struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
                .ignoresSafeArea()

            ProgressView("Please wait...")
                .foregroundStyle(Theme.primaryText)
                .padding(24)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}
