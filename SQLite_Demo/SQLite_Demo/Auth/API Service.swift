//
//  API Service.swift
//  SQLite_Demo
//
//  Created by Apps WeLove on 07/07/26.
//

import Foundation

protocol SignupAPIServiceProtocol {
    func checkEmailExists(email: String) async throws -> Bool
    func registerUser(request: SignupRequest) async throws
    func verifyOTP(email: String, otp: String) async throws -> Bool
}

final class SignupAPIService: SignupAPIServiceProtocol {

    private let baseURL = "https://your-api.com"

    func checkEmailExists(email: String) async throws -> Bool {
        guard let url = URL(string: "\(baseURL)/auth/check-email") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["email": email]
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        let result = try JSONDecoder().decode(EmailCheckResponse.self, from: data)
        return result.exists
    }

    func registerUser(request signupRequest: SignupRequest) async throws {
        guard let url = URL(string: "\(baseURL)/auth/signup") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(signupRequest)

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
    }

    func verifyOTP(email: String, otp: String) async throws -> Bool {
        guard let url = URL(string: "\(baseURL)/auth/verify-otp") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = OTPVerifyRequest(email: email, otp: otp)
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        struct OTPResponse: Codable {
            let verified: Bool
        }

        let result = try JSONDecoder().decode(OTPResponse.self, from: data)
        return result.verified
    }
}
