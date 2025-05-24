//
//  MoruMeAPIUserRepository.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/24.
//

import Foundation

final class MoruMeAPIUserRepository: UserRepository {
    private let apiService: APIService

    init() {
        let authService = FirebaseAuthService()
        self.apiService = MoruMeAPIService(authService: authService)
    }

    @discardableResult
    func addUser(nickname: String, avatarURL: URL?, filterParameters: FilterParameters) async throws -> User {
        let requestBody = CreateUserRequestBody(nickname: nickname, avatarURL: avatarURL, filter: filterParameters)
        return try await apiService.put(endpoint: "api/users", body: requestBody)
    }

    func fetchMyUser() async throws -> User {
        try await apiService.get(endpoint: "api/users/me")
    }

    func fetchUsers() async throws -> [User] {
        try await apiService.get(endpoint: "api/users/list")
    }
}
