//
//  MoruMeAPIService.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/24.
//

import Foundation
import OSLog

final class MoruMeAPIService: APIService {
    private let authService: AuthService
    private let session: URLSession
    private let baseURL = "https://morume-217413024104.us-central1.run.app/"
    private let logger = Logger(subsystem: "com.morume.app", category: "APIService")

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
            logger.debug("📥 デコード成功: \(String(describing: T.self))")
            return result
        } catch {
            logger.error("❌ デコードエラー: \(error.localizedDescription), 型: \(T.self)")
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
            logger.error("❌ 無効なURL: \(self.baseURL + endpoint)")
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // リクエストの情報をログに出力
        logger.info("📤 リクエスト: \(request.httpMethod!) \(url.absoluteString)")

        // リクエストボディがある場合はログに出力
        if let body = body, let jsonString = String(data: body, encoding: .utf8) {
            logger.info("📤 リクエストボディ: \(jsonString)")
        }

        // AuthServiceからトークンを取得してBearerトークンとして設定
        do {
            let token = try await authService.getToken()
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            logger.debug("🔑 認証トークン設定")
        } catch {
            logger.error("❌ 認証エラー: \(error.localizedDescription)")
            throw APIError.authenticationError
        }

        if let body = body {
            request.httpBody = body
        }

        do {
            let startTime = Date()
            let (data, response) = try await session.data(for: request)
            let timeInterval = Date().timeIntervalSince(startTime)

            guard let httpResponse = response as? HTTPURLResponse else {
                logger.error("❌ 無効なレスポンス形式")
                throw APIError.networkError(NSError(domain: "Invalid response", code: 0, userInfo: nil))
            }

            // レスポンス情報のログ出力
            logger.info("📥 レスポンス: \(httpResponse.statusCode) - \(endpoint) (\(String(format: "%.3f", timeInterval))秒)")

            // レスポンスボディのログ出力（JSONの場合）
            if let jsonString = String(data: data, encoding: .utf8) {
                if jsonString.count > 1000 {
                    // 長すぎるレスポンスは先頭部分だけを表示
                    logger.debug("📥 レスポンスボディ(先頭1000文字): \(jsonString.prefix(1000))...")
                } else {
                    logger.debug("📥 レスポンスボディ: \(jsonString)")
                }
            }

            switch httpResponse.statusCode {
            case 200...299:
                return data
            case 401:
                logger.error("❌ 認証エラー: 401 Unauthorized")
                throw APIError.authenticationError
            default:
                logger.error("❌ サーバーエラー: \(httpResponse.statusCode)")
                throw APIError.serverError(httpResponse.statusCode)
            }
        } catch let error as APIError {
            throw error
        } catch {
            logger.error("❌ ネットワークエラー: \(error.localizedDescription)")
            throw APIError.networkError(error)
        }
    }
}
