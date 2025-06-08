//
//  APIService.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/24.
//

import Foundation

/// HTTPリクエストのメソッドを表す列挙型
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

/// APIエラータイプを表す列挙型
enum APIError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
    case serverError(Int)
    case authenticationError
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "無効なURLです"
        case .noData:
            return "データが見つかりません"
        case .decodingError:
            return "データの解析に失敗しました"
        case .networkError:
            return "ネットワークエラーが発生しました"
        case .serverError(let statusCode):
            return "サーバーエラーが発生しました (コード: \(statusCode))"
        case .authenticationError:
            return "認証に失敗しました"
        case .invalidResponse:
            return "無効なレスポンス形式です"
        }
    }
}

// MARK: - APIService
/// APIサービスのインターフェース
protocol APIService {
    /// Codableな型を受け取るリクエスト
    func request<T: Codable>(
        endpoint: String,
        method: HTTPMethod,
        body: Data?
    ) async throws -> T

    /// レスポンスボディを必要としないリクエスト
    func request(
        endpoint: String,
        method: HTTPMethod,
        body: Data?
    ) async throws
}

extension APIService {
    func get<T: Codable>(endpoint: String) async throws -> T {
        return try await request(endpoint: endpoint, method: .get, body: nil)
    }

    func put<T: Codable, U: Encodable>(endpoint: String, body: U) async throws -> T {
        let data = try JSONEncoder().encode(body)
        return try await request(endpoint: endpoint, method: .put, body: data)
    }
}
