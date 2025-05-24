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
enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
    case serverError(Int)
    case authenticationError
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
