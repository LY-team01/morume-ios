//
//  AuthService.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/24.
//

import FirebaseAuth

protocol AuthService {
    func login() async throws
    func getToken() async throws -> String
}

final class FirebaseAuthService: AuthService {
    private let auth = Auth.auth()

    func login() async throws {
        if auth.currentUser == nil {
            try await auth.signInAnonymously()
        }
    }

    func getToken() async throws -> String {
        guard let user = auth.currentUser else {
            throw NSError(domain: "User not authenticated", code: 401, userInfo: nil)
        }
        return try await user.getIDToken(forcingRefresh: true)
    }
}
