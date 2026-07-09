//
//  LoginView.swift
//  SQLite_Demo
//
//  Created by Apps WeLove on 07/07/26.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    let onSignupTap: () -> Void
    let onLoginSuccess: (String) -> Void

    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()

            VStack(spacing: 28) {
                Spacer()

                VStack(spacing: 10) {
                    Text("Welcome Back")
                        .font(.largeTitle.bold())
                        .foregroundStyle(Theme.primaryText)

                    Text("Sign in to your local account.")
                        .font(.subheadline)
                        .foregroundStyle(Theme.secondaryText)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 16) {
                    TextField("Email address", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding()
                        .background(Theme.cardBackground)
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.border, lineWidth: 1))
                        .clipShape(RoundedRectangle(cornerRadius: 14))

                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .background(Theme.cardBackground)
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.border, lineWidth: 1))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                VStack(spacing: 14) {
                    PrimaryButton(title: "Log In") {
                        viewModel.handleLogin(onSuccess: onLoginSuccess)
                    }

                    Button {
                        onSignupTap()
                    } label: {
                        HStack {
                            Text("Don't have an account?")
                                .foregroundStyle(Theme.secondaryText)
                            Text("Sign Up")
                                .fontWeight(.bold)
                                .foregroundStyle(Theme.accent)
                        }
                    }
                    .font(.subheadline)
                    .padding(.top, 4)
                }

                Spacer()
            }
            .padding()

            if viewModel.isLoading {
                LoadingOverlay()
            }
        }
        .alert("Login Failed", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}
