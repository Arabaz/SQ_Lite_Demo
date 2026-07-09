//
//  RootView.swift
//  SQLite_Demo
//
//  Created by Apps WeLove on 07/07/26.
//

import SwiftUI

enum AppFlow {
    case login
    case signup
    case mainApp
}

struct RootView: View {
    @EnvironmentObject var session: SessionManager
    @State private var isShowingSignup = false
    var body: some View {
        Group {
            if session.isLoggedIn {
                MainTabBarView()
            } else if isShowingSignup {
                SignupFlowView()
                    .environment(\.onSignupCancel) {
                        isShowingSignup = false
                    }
                    .environment(\.onSignupFinished) {
                        // User signed up, log them in locally
                        // Ensure you pass the viewmodel's email here
                    }
            } else {
                LoginView(
                    onSignupTap: {
                        isShowingSignup = true
                    },
                    onLoginSuccess: { email in
                        session.login(email: email)
                    }
                )
            }
        }
    }
}

// Custom environments to pass callbacks back from signup steps
private struct SignupCancelKey: EnvironmentKey {
    static let defaultValue: () -> Void = {}
}

private struct SignupFinishedKey: EnvironmentKey {
    static let defaultValue: () -> Void = {}
}

extension EnvironmentValues {
    var onSignupCancel: () -> Void {
        get { self[SignupCancelKey.self] }
        set { self[SignupCancelKey.self] = newValue }
    }

    var onSignupFinished: () -> Void {
        get { self[SignupFinishedKey.self] }
        set { self[SignupFinishedKey.self] = newValue }
    }
}
