//
//  Models.swift
//  SQLite_Demo
//
//  Created by Apps WeLove on 07/07/26.
//

import Foundation

enum Gender: String, CaseIterable, Identifiable, Codable {
    case male = "Male"
    case female = "Female"
    case other = "Other"
    case preferNotToSay = "Prefer not to say"

    var id: String { rawValue }
}

struct SignupRequest: Codable {
    let email: String
    let password: String
    let firstName: String
    let lastName: String
    let address: String
    let gender: String
    let acceptedDeclaration: Bool
}

struct EmailCheckResponse: Codable {
    let exists: Bool
}

struct OTPVerifyRequest: Codable {
    let email: String
    let otp: String
}


struct UserProfile {
    let email: String
    let firstName: String
    let lastName: String
    let address: String
    let gender: String
    let imagePath: String?
}
