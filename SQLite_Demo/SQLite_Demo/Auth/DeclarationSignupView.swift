//
//  DeclarationSignupView.swift
//  SQLite_Demo
//
//  Created by Apps WeLove on 07/07/26.
//

import SwiftUI

struct DeclarationSignupView: View {

    @ObservedObject var viewModel: SignupViewModel

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            SignupHeaderView(
                title: "Declaration",
                subtitle: "Please review and accept before continuing."
            )

            Toggle(isOn: $viewModel.hasAcceptedDeclaration) {
                Text("""
                I confirm that the information provided by me is correct. I agree to the Terms of Service and Privacy Policy.
                """)
                .font(.subheadline)
            }
            .toggleStyle(CheckboxToggleStyle())

            PrimaryButton(title: "Continue") {
                viewModel.continueFromDeclaration()
            }

            Spacer()
        }
        .padding()
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: configuration.isOn
                      ? "checkmark.square.fill"
                      : "square")
                .font(.title3)
                .foregroundStyle(configuration.isOn ? Theme.accent : Theme.secondaryText)

                configuration.label
                    .foregroundStyle(Theme.primaryText)
            }
        }
    }
}
