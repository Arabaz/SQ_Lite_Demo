//
//  OTPVerificationView.swift
//  SQLite_Demo
//
//  Created by Apps WeLove on 07/07/26.
//

import SwiftUI

struct OTPVerificationView: View {

    @ObservedObject var viewModel: SignupViewModel

    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                Spacer()

                SignupHeaderView(
                    title: "Verify your email",
                    subtitle: "We sent a 6-digit verification code to \(viewModel.email)."
                )

                TextField("Enter OTP", text: $viewModel.otp)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .font(.title2.bold())
                    .foregroundStyle(Theme.primaryText)
                    .padding()
                    .background(Theme.cardBackground)
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.border, lineWidth: 1))
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                PrimaryButton(title: "Verify OTP") {
                    viewModel.verifyOTP()
                }

                Spacer()
            }
            .padding()

            if viewModel.isLoading {
                LoadingOverlay()
            }
        }
    }
}
