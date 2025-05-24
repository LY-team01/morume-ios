//
//  MoruMeAPIFilterRepository.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/24.
//

final class MoruMeAPIFilterRepository: FilterRepository {
    private let apiService: MoruMeAPIService

    init() {
        let authService = FirebaseAuthService()
        self.apiService = MoruMeAPIService(authService: authService)
    }

    func fetchMyFilter() async throws -> Filter {
        try await apiService.get(endpoint: "/api/filters/me")
    }

    func fetchFilter(userID: String) async throws -> Filter {
        try await apiService.get(endpoint: "/api/filters/\(userID)")
    }
}
