//
//  PasswordSignupView.swift
//  SQLite_Demo
//
//  Created by Apps WeLove on 07/07/26.
//

import SwiftUI

struct PasswordSignupView: View {

    @ObservedObject var viewModel: SignupViewModel

    var body: some View {
        VStack(spacing: 22) {
            Spacer()

            SignupHeaderView(
                title: "Create password",
                subtitle: "Use at least 8 characters for better security."
            )

            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Theme.cardBackground)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.border, lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 14))

            SecureField("Confirm password", text: $viewModel.confirmPassword)
                .padding()
                .background(Theme.cardBackground)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.border, lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 14))

            PrimaryButton(title: "Continue") {
                viewModel.continueFromPassword()
            }

            Spacer()
        }
        .padding()
    }
}
