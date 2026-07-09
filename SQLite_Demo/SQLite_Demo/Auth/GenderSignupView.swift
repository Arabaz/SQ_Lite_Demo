//
//  GenderSignupView.swift
//  SQLite_Demo
//
//  Created by Apps WeLove on 07/07/26.
//

import SwiftUI

struct GenderSignupView: View {

    @ObservedObject var viewModel: SignupViewModel

    var body: some View {
        VStack(spacing: 22) {
            Spacer()

            SignupHeaderView(
                title: "Select gender",
                subtitle: "This helps us personalize your experience."
            )

            VStack(spacing: 12) {
                ForEach(Gender.allCases) { gender in
                    Button {
                        viewModel.selectedGender = gender
                    } label: {
                        HStack {
                            Text(gender.rawValue)
                                .foregroundStyle(Theme.primaryText)

                            Spacer()

                            Image(systemName: viewModel.selectedGender == gender
                                  ? "checkmark.circle.fill"
                                  : "circle")
                            .foregroundStyle(viewModel.selectedGender == gender ? Theme.accent : Theme.secondaryText)
                        }
                        .padding()
                        .background(Theme.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(viewModel.selectedGender == gender ? Theme.accent : Theme.border, lineWidth: viewModel.selectedGender == gender ? 1.5 : 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
            }

            PrimaryButton(title: "Continue") {
                viewModel.continueFromGender()
            }

            Spacer()
        }
        .padding()
    }
}
