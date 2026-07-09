//
//  SignupFlowView.swift
//  SQLite_Demo
//
//  Created by Apps WeLove on 07/07/26.
//

import SwiftUI

struct SignupFlowView: View {

    @StateObject private var viewModel = SignupViewModel()
    @Environment(\.onSignupCancel) var cancelSignup
    @Environment(\.onSignupFinished) var finishSignup

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background
                    .ignoresSafeArea()
                contentView
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                // Modified back button:
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        if viewModel.currentStep == .email {
                            cancelSignup() // Returns to login screen
                        } else {
                            viewModel.goToPreviousStep()
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
            }
        }
        .alert("Signup", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.currentStep {
        case .email:
            EmailSignupView(viewModel: viewModel)

        case .password:
            PasswordSignupView(viewModel: viewModel)

        case .name:
            NameSignupView(viewModel: viewModel)

        case .address:
            AddressSignupView(viewModel: viewModel)
            
        case .profilePicture:
            ProfilePictureSignupView(viewModel: viewModel)

        case .gender:
            GenderSignupView(viewModel: viewModel)

        case .declaration:
            DeclarationSignupView(viewModel: viewModel)

        case .review:
            ReviewSignupView(viewModel: viewModel)

        case .otp:
            OTPVerificationView(viewModel: viewModel)

        case .success:
            SignupSuccessView {
                viewModel.resetData()
                finishSignup()
            }
        }
    }
}

#Preview {
    SignupFlowView()
}
