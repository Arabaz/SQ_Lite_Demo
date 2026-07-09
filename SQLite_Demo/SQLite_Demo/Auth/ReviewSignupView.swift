//
//  ReviewSignupView.swift
//  SQLite_Demo
//
//  Created by Apps WeLove on 07/07/26.
//

import SwiftUI

struct ReviewSignupView: View {

    @ObservedObject var viewModel: SignupViewModel

    var body: some View {
        ZStack {
            VStack(spacing: 22) {
                ScrollView {
                    VStack(spacing: 20) {
                        SignupHeaderView(
                            title: "Review your details",
                            subtitle: "Please confirm your information before creating your account."
                        )

                        if let image = viewModel.selectedProfileImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 110, height: 110)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Theme.border, lineWidth: 1))
                                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                                .padding(.vertical, 8)
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 110, height: 110)
                                .foregroundStyle(Theme.secondaryText)
                                .padding(.vertical, 8)
                        }

                        VStack(spacing: 14) {
                            ReviewRow(title: "Email", value: viewModel.email)
                            ReviewRow(title: "Name", value: "\(viewModel.firstName) \(viewModel.lastName)")
                            ReviewRow(
                                title: "Address",
                                value: "\(viewModel.houseNumber), \(viewModel.street) \(viewModel.zipCode), \(viewModel.landmark.isEmpty ? "" : viewModel.landmark + "\n")\(viewModel.city), \(viewModel.state) - \(viewModel.zipCode)"
                            )
                            ReviewRow(title: "Gender", value: viewModel.selectedGender?.rawValue ?? "")
                        }
                    }
                    .padding(.top)
                }

                PrimaryButton(title: "Create Account") {
                        viewModel.submitSignup()
                }
            }
            .padding()

            if viewModel.isLoading {
                LoadingOverlay()
            }
        }
    }
}

struct ReviewRow: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(Theme.secondaryText)

            Text(value)
                .font(.body.weight(.medium))
                .foregroundStyle(Theme.primaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Theme.cardBackground)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.border, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
