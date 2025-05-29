//
//  UserSelectViewModel.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/30.
//

import Observation

@MainActor
@Observable
final class UserSelectViewModel {
    private let userRepository: UserRepository

    var allUsers: [User] = []
    var isProcessing = false

    init() {
        userRepository = MoruMeAPIUserRepository()
    }

    func fetchAllUsers() async throws {
        isProcessing = true
        defer { isProcessing = false }

        allUsers = try await userRepository.fetchUsers()
    }

    func refreshUsers() async throws {
        allUsers = try await userRepository.fetchUsers()
    }
}
