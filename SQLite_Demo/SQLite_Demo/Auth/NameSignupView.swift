//
//  NameSignupView.swift
//  SQLite_Demo
//
//  Created by Apps WeLove on 07/07/26.
//

import SwiftUI

struct NameSignupView: View {

    @ObservedObject var viewModel: SignupViewModel

    var body: some View {
        VStack(spacing: 22) {
            Spacer()

            SignupHeaderView(
                title: "Tell us about you",
                subtitle: "Enter your name as you want it to appear in your profile."
            )

            TextField("First name", text: $viewModel.firstName)
                .padding()
                .background(Theme.cardBackground)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.border, lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 14))

            TextField("Last name", text: $viewModel.lastName)
                .padding()
                .background(Theme.cardBackground)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.border, lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 14))

            PrimaryButton(title: "Continue") {
                viewModel.continueFromName()
            }

            Spacer()
        }
        .padding()
    }
}
