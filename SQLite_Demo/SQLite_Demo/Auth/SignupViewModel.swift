//
//  SignupViewModel.swift
//  SQLite_Demo
//
//  Created by Apps WeLove on 07/07/26.
//

import SwiftUI
import PhotosUI
internal import Combine

enum SignupStep: Int {
    case email
    case password
    case name
    case address
    case profilePicture
    case gender
    case declaration
    case review
    case otp
    case success
}

@MainActor
final class SignupViewModel: ObservableObject {

    @Published var currentStep: SignupStep = .email

    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""

    @Published var firstName = ""
    @Published var lastName = ""

    @Published var houseNumber = ""
    @Published var street = ""
    @Published var landmark = ""
    @Published var city = ""
    @Published var state = ""
    @Published var zipCode = ""

    @Published var selectedProfileImage: UIImage?
    @Published var selectedPhotoItem: PhotosPickerItem?

    @Published var selectedGender: Gender?

    @Published var hasAcceptedDeclaration = false
    @Published var otp = ""

    @Published var isLoading = false
    @Published var alertMessage = ""
    @Published var showAlert = false

    private let apiService: SignupAPIServiceProtocol

    init(apiService: SignupAPIServiceProtocol = SignupAPIService()) {
        self.apiService = apiService
    }


    func continueFromEmail() {
          guard isValidEmail(email) else {
              showError("Please enter a valid email address.")
              return
          }
          isLoading = true
          Task {
              let emailExists = DatabaseManager.shared.checkEmailExists(email: email)
              if emailExists {
                  showError("This email is already registered. Please use another email or log in.")
              } else {
                  currentStep = .password
              }
              isLoading = false
          }
      }


    func continueFromPassword() {
        guard password.count >= 8 else {
            showError("Password must contain at least 8 characters.")
            return
        }

        guard password == confirmPassword else {
            showError("Password and confirm password do not match.")
            return
        }

        currentStep = .name
    }

    func continueFromName() {
        guard !firstName.trimmingCharacters(in: .whitespaces).isEmpty else {
            showError("Please enter your first name.")
            return
        }

        guard !lastName.trimmingCharacters(in: .whitespaces).isEmpty else {
            showError("Please enter your last name.")
            return
        }

        currentStep = .address
    }

    func continueFromAddress() {
        guard !houseNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showError("Please enter your house or flat number.")
            return
        }

        guard !street.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showError("Please enter your street or area.")
            return
        }

        guard !city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showError("Please enter your city.")
            return
        }

        guard !state.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showError("Please enter your state.")
            return
        }

        guard zipCode.count >= 4 else {
            showError("Please enter a valid ZIP or postal code.")
            return
        }

        currentStep = .profilePicture
    }

    func loadProfileImage() async {
        guard let selectedPhotoItem else { return }

        do {
            if let data = try await selectedPhotoItem.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                selectedProfileImage = image
            }
        } catch {
            showError("Unable to load selected profile picture.")
        }
    }

    func continueFromProfilePicture() {
        currentStep = .gender
    }

    func continueFromGender() {
        guard selectedGender != nil else {
            showError("Please select your gender.")
            return
        }

        currentStep = .declaration
    }

    func continueFromDeclaration() {
        guard hasAcceptedDeclaration else {
            showError("Please accept the declaration to continue.")
            return
        }

        currentStep = .review
    }

    func submitSignup() {
            guard let selectedGender else { return }
            isLoading = true
            let fullAddress = "House/Flat No: \(houseNumber), Street/Area: \(street), Landmark: \(landmark), City: \(city), State: \(state) - \(zipCode)"
            let request = SignupRequest(
                email: email,
                password: password,
                firstName: firstName,
                lastName: lastName,
                address: fullAddress,
                gender: selectedGender.rawValue,
                acceptedDeclaration: hasAcceptedDeclaration
            )
            Task {
                do {
                    currentStep = .otp // for testing
                    try await apiService.registerUser(request: request)
                    currentStep = .otp
                } catch {
                    showError("Unable to create your account. Please try again.")
                }
                isLoading = false
            }
        }

    func verifyOTP() {
            guard otp.count == 6 else {
                showError("Please enter a valid 6-digit OTP.")
                return
            }
            isLoading = true
            Task {
                let isVerified = true //try await apiService.verifyOTP(email: email, otp: otp)
                if isVerified {
                    var profileImagePath: String? = nil
                    if let profileImage = selectedProfileImage {
                        profileImagePath = saveImageToDisk(image: profileImage, filename: "\(email.lowercased())_profile")
                    }

                    let fullAddress = "House/Flat No: \(houseNumber), Street/Area: \(street), Landmark: \(landmark), City: \(city), State: \(state) - \(zipCode)"

                    let isSaved = DatabaseManager.shared.insertUser(
                        email: email.lowercased(),
                        firstName: firstName,
                        lastName: lastName,
                        address: fullAddress,
                        gender: selectedGender?.rawValue ?? "Prefer not to say",
                        imagePath: profileImagePath
                    )

                    if isSaved {
                        UserDefaults.standard.set(email.lowercased(), forKey: "loggedInUserEmail")
                        currentStep = .success
                    } else {
                        showError("OTP verified, but failed to save details locally.")
                    }
                } else {
                    showError("Invalid OTP. Please check your email and try again.")
                }
                isLoading = false
            }
        }

    func goToPreviousStep() {
        guard currentStep.rawValue > SignupStep.email.rawValue else { return }

        currentStep = SignupStep(rawValue: currentStep.rawValue - 1) ?? .email
    }

    private func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES[c] %@", pattern).evaluate(with: email)
    }

    private func showError(_ message: String) {
        alertMessage = message
        showAlert = true
    }

    func resetData() {
            email = ""
            password = ""
            confirmPassword = ""
            firstName = ""
            lastName = ""
            houseNumber = ""
            street = ""
            landmark = ""
            city = ""
            state = ""
            zipCode = ""
            selectedProfileImage = nil
            selectedPhotoItem = nil
            selectedGender = nil
            hasAcceptedDeclaration = false
            otp = ""
            isLoading = false
            currentStep = .email
        }
    
}

extension SignupViewModel {
    private func saveImageToDisk(image: UIImage, filename: String) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        do {
            let directory = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            let fileURL = directory.appendingPathComponent("\(filename).jpg")
            try data.write(to: fileURL)
            return fileURL.path
        } catch {
            print("Failed to save image to disk: \(error.localizedDescription)")
            return nil
        }
    }
}
