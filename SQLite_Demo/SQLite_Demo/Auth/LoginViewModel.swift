//
//  LoginViewModel.swift
//  SQLite_Demo
//
//  Created by Apps WeLove on 07/07/26.
//

import SwiftUI
internal import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var alertMessage = ""
    @Published var showAlert = false

    func handleLogin(onSuccess: (String) -> Void) {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard !trimmedEmail.isEmpty else {
            showError("Please enter your email.")
            return
        }

        guard password == "12345678" else {
            showError("Incorrect password. (Use static: 12345678)")
            return
        }

        isLoading = true

        let emailExists = DatabaseManager.shared.checkEmailExists(email: trimmedEmail)

        if emailExists {
            onSuccess(trimmedEmail)
        } else {
            showError("Email not found. Please sign up first.")
        }

        isLoading = false
    }

    private func showError(_ message: String) {
        alertMessage = message
        showAlert = true
    }
}

