//
//  SignupSuccessView.swift
//  SQLite_Demo
//
//  Created by Apps WeLove on 07/07/26.
//

import SwiftUI

struct SignupSuccessView: View {

    let continueAction: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 90))
                .foregroundStyle(Theme.success)

            Text("Welcome!")
                .font(.largeTitle.bold())
                .foregroundStyle(Theme.primaryText)

            Text("Your account has been created successfully.")
                .font(.body)
                .foregroundStyle(Theme.secondaryText)
                .multilineTextAlignment(.center)

            PrimaryButton(title: "Continue to App") {
                continueAction()
            }

            Spacer()
        }
        .padding()
    }
}
