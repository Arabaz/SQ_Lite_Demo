//
//  ProfilePictureSignupView.swift
//  SQLite_Demo
//
//  Created by Apps WeLove on 07/07/26.
//

import SwiftUI
import PhotosUI

struct ProfilePictureSignupView: View {

    @ObservedObject var viewModel: SignupViewModel

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            SignupHeaderView(
                title: "Add profile picture",
                subtitle: "Choose a photo so people can recognize you."
            )

            PhotosPicker(
                selection: $viewModel.selectedPhotoItem,
                matching: .images
            ) {
                ZStack {
                    Circle()
                        .fill(Theme.cardBackground)
                        .frame(width: 150, height: 150)
                        .overlay(Circle().stroke(Theme.border, lineWidth: 1.5))
                        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)

                    if let image = viewModel.selectedProfileImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                    } else {
                        VStack(spacing: 10) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 34))
                                .foregroundStyle(Theme.secondaryText)

                            Text("Add Photo")
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(Theme.secondaryText)
                        }
                    }
                }
            }
            .onChange(of: viewModel.selectedPhotoItem) { _, _ in
                Task {
                    await viewModel.loadProfileImage()
                }
            }

            Text("You can update this later from your profile.")
                .font(.footnote)
                .foregroundStyle(Theme.secondaryText)
                .multilineTextAlignment(.center)

            PrimaryButton(title: "Continue") {
                viewModel.continueFromProfilePicture()
            }

            Button("Skip for now") {
                viewModel.continueFromProfilePicture()
            }
            .font(.subheadline.weight(.medium))
            .foregroundStyle(Theme.accent)

            Spacer()
        }
        .padding()
    }
}
