//
//  MoruMeAPIService.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/24.
//

import Foundation

final class MoruMeAPIService: APIService {
    private let authService: AuthService
    private let session: URLSession
    private let baseURL = "https://morume-217413024104.us-central1.run.app/"

    /// 初期化メソッド
    /// - Parameters:
    ///   - authService: 認証を担当するサービス
    ///   - session: URLSession（テスト用にオーバーライド可能）
    init(authService: AuthService, session: URLSession = .shared) {
        self.authService = authService
        self.session = session
    }

    /// Codableな型を返すリクエストの実装
    /// - Parameters:
    ///   - endpoint: リクエスト先のエンドポイント
    ///   - method: HTTPメソッド
    ///   - body: リクエストボディ（省略可）
    /// - Returns: デコードされたレスポンス
    func request<T: Codable>(endpoint: String, method: HTTPMethod, body: Data? = nil) async throws -> T {
        let data = try await performRequest(endpoint: endpoint, method: method, body: body)

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601

            let result = try decoder.decode(T.self, from: data)
            return result
        } catch {
            throw APIError.decodingError
        }
    }

    /// レスポンスボディを必要としないリクエストの実装
    /// - Parameters:
    ///   - endpoint: リクエスト先のエンドポイント
    ///   - method: HTTPメソッド
    ///   - body: リクエストボディ（省略可）
    func request(endpoint: String, method: HTTPMethod, body: Data? = nil) async throws {
        _ = try await performRequest(endpoint: endpoint, method: method, body: body)
    }

    /// 実際のHTTPリクエストを実行する内部メソッド
    /// - Parameters:
    ///   - endpoint: リクエスト先のエンドポイント
    ///   - method: HTTPメソッド
    ///   - body: リクエストボディ（省略可）
    /// - Returns: レスポンスデータ
    private func performRequest(endpoint: String, method: HTTPMethod, body: Data?) async throws -> Data {
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // AuthServiceからトークンを取得してBearerトークンとして設定
        do {
            let token = try await authService.getToken()
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } catch {
            throw APIError.authenticationError
        }

        if let body = body {
            request.httpBody = body
        }

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.networkError(NSError(domain: "Invalid response", code: 0, userInfo: nil))
            }

            switch httpResponse.statusCode {
            case 200...299:
                return data
            case 401:
                throw APIError.authenticationError
            default:
                throw APIError.serverError(httpResponse.statusCode)
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
}

extension MoruMeAPIService {
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

extension MoruMeAPIService {
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
