//
//  ProfileView.swift
//  SQLite_Demo
//
//  Created by Apps WeLove on 07/07/26.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var session: SessionManager
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    if let user = viewModel.profile {
                        // User Profile Image
                        if let path = user.imagePath,
                           let uiImage = UIImage(contentsOfFile: path) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Theme.border, lineWidth: 1))
                                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .foregroundStyle(Theme.secondaryText)
                        }

                        // Header details
                        VStack(spacing: 4) {
                            Text("\(user.firstName) \(user.lastName)")
                                .font(.title2.bold())
                                .foregroundStyle(Theme.primaryText)

                            Text(user.email)
                                .font(.subheadline)
                                .foregroundStyle(Theme.secondaryText)
                        }

                        // Detail Fields
                        VStack(spacing: 16) {
                            profileDetailField(title: "Gender", value: user.gender)
                            profileDetailField(title: "Address", value: user.address)
                        }
                        .padding(.horizontal)

                        // Log Out Button
                        Button(role: .destructive) {
                            session.logout()
                        } label: {
                            Text("Log Out")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Color.red.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .padding(.horizontal)
                        .padding(.top, 12)

                    } else {
                        VStack {
                            ProgressView("Loading Profile...")
                                .foregroundStyle(Theme.primaryText)
                        }
                        .padding(.top, 100)
                    }
                }
                .padding(.top)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let email = session.currentUserEmail {
                viewModel.loadUserProfile(email: email)
            }
        }
    }

    @ViewBuilder
    private func profileDetailField(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(Theme.secondaryText)

            Text(value)
                .font(.body.weight(.medium))
                .foregroundStyle(Theme.primaryText)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Theme.cardBackground)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.border, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
