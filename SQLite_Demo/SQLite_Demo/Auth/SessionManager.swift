//
//  SessionManager.swift
//  SQLite_Demo
//
//  Created by Apps WeLove on 07/07/26.
//

import SwiftUI
internal import Combine

final class SessionManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentUserEmail: String? = nil

    init() {
        // Auto-login check on app launch
        if let email = UserDefaults.standard.string(forKey: "loggedInUserEmail") {
            self.currentUserEmail = email
            self.isLoggedIn = true
        }
    }

    func login(email: String) {
        let cleanEmail = email.lowercased()
        UserDefaults.standard.set(cleanEmail, forKey: "loggedInUserEmail")
        self.currentUserEmail = cleanEmail
        self.isLoggedIn = true
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: "loggedInUserEmail")
        self.currentUserEmail = nil
        self.isLoggedIn = false
    }
}
