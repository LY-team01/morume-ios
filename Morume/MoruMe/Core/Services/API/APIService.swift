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

extension APIService {
    /// GET リクエストの簡易メソッド
    func get<T: Codable>(endpoint: String) async throws -> T {
        return try await request(endpoint: endpoint, method: .get, body: nil)
    }

    /// POST リクエストの簡易メソッド
    func post<T: Codable>(endpoint: String, body: Data? = nil) async throws -> T {
        return try await request(endpoint: endpoint, method: .post, body: body)
    }

    /// PUT リクエストの簡易メソッド
    func put<T: Codable>(endpoint: String, body: Data? = nil) async throws -> T {
        return try await request(endpoint: endpoint, method: .put, body: body)
    }

    /// DELETE リクエストの簡易メソッド
    func delete(endpoint: String) async throws {
        try await request(endpoint: endpoint, method: .delete, body: nil)
    }

    /// PATCH リクエストの簡易メソッド
    func patch<T: Codable>(endpoint: String, body: Data? = nil) async throws -> T {
        return try await request(endpoint: endpoint, method: .patch, body: body)
    }
}

extension APIService {
    /// エンコード可能なオブジェクトを使った POST リクエスト
    func post<T: Codable, U: Encodable>(endpoint: String, body: U) async throws -> T {
        let data = try JSONEncoder().encode(body)
        return try await post(endpoint: endpoint, body: data)
    }

    /// エンコード可能なオブジェクトを使った PUT リクエスト
    func put<T: Codable, U: Encodable>(endpoint: String, body: U) async throws -> T {
        let data = try JSONEncoder().encode(body)
        return try await put(endpoint: endpoint, body: data)
    }

    /// エンコード可能なオブジェクトを使った PATCH リクエスト
    func patch<T: Codable, U: Encodable>(endpoint: String, body: U) async throws -> T {
        let data = try JSONEncoder().encode(body)
        return try await patch(endpoint: endpoint, body: data)
    }
}
