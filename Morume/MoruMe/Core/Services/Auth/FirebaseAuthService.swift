//
//  FirebaseAuthService.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/24.
//

import FirebaseAuth

// AuthErrorをインポート（実際のプロジェクトではこのimportは不要かもしれません）

final class FirebaseAuthService: AuthService {
    private let auth = Auth.auth()

    func login() async throws {
        if auth.currentUser == nil {
            do {
                try await auth.signInAnonymously()
            } catch {
                throw AuthError.anonymousSignInFailed
            }
        }
    }

    func getToken() async throws -> String {
        guard let user = auth.currentUser else {
            throw AuthError.userNotAuthenticated
        }

        do {
            return try await user.getIDToken(forcingRefresh: true)
        } catch {
            throw AuthError.tokenRetrievalFailed
        }
    }
}
