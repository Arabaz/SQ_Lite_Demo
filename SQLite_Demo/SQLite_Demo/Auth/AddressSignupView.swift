//
//  AddressSignupView.swift
//  SQLite_Demo
//
//  Created by Apps WeLove on 07/07/26.
//

import SwiftUI

struct AddressSignupView: View {

    @ObservedObject var viewModel: SignupViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                SignupHeaderView(
                    title: "Add your address",
                    subtitle: "Please provide your address details."
                )

                addressTextField(
                    title: "House / Flat Number",
                    placeholder: "e.g. B-204",
                    text: $viewModel.houseNumber
                )

                addressTextField(
                    title: "Street / Area",
                    placeholder: "e.g. MG Road, Indore",
                    text: $viewModel.street
                )

                addressTextField(
                    title: "Landmark",
                    placeholder: "e.g. Near City Mall",
                    text: $viewModel.landmark
                )

                addressTextField(
                    title: "City",
                    placeholder: "Enter city",
                    text: $viewModel.city
                )

                addressTextField(
                    title: "State",
                    placeholder: "Enter state",
                    text: $viewModel.state
                )

                addressTextField(
                    title: "ZIP / Postal Code",
                    placeholder: "Enter ZIP code",
                    text: $viewModel.zipCode,
                    keyboardType: .numberPad
                )

                PrimaryButton(title: "Continue") {
                    viewModel.continueFromAddress()
                }
                .padding(.top, 8)
            }
            .padding()
        }
    }

    @ViewBuilder
    private func addressTextField(
        title: String,
        placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Theme.primaryText)

            TextField(placeholder, text: text)
                .keyboardType(keyboardType)
                .padding()
                .background(Theme.cardBackground)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.border, lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}
