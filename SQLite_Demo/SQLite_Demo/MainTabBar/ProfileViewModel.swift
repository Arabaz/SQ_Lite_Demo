//
//  ProfileViewModel.swift
//  SQLite_Demo
//
//  Created by Apps WeLove on 07/07/26.
//

import SwiftUI
internal import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile? = nil

    func loadUserProfile(email: String) {
        self.profile = DatabaseManager.shared.getUser(email: email)
    }
}
