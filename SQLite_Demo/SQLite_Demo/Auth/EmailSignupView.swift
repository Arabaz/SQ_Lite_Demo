//
//  EmailSignupView.swift
//  SQLite_Demo
//
//  Created by Apps WeLove on 07/07/26.
//

import SwiftUI

struct EmailSignupView: View {

    @ObservedObject var viewModel: SignupViewModel

    var body: some View {
        ZStack {
            VStack(spacing: 28) {
                Spacer()

                SignupHeaderView(
                    title: "Create your account",
                    subtitle: "Enter your email address to get started."
                )

                TextField("Email address", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding()
                    .background(Theme.cardBackground)
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.border, lineWidth: 1))
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                PrimaryButton(title: "Continue") {
                    viewModel.continueFromEmail()
                }

                Spacer()
            }
            .padding()

            if viewModel.isLoading {
                LoadingOverlay()
            }
        }
    }
}
