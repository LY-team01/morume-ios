//
//  AuthError.swift
//  MoruMe
//
//  Created by System on 2025/06/08.
//

import Foundation

/// 認証関連のエラー
enum AuthError: Error, LocalizedError {
    case userNotAuthenticated  // ユーザー未認証
    case tokenRetrievalFailed  // トークン取得失敗
    case anonymousSignInFailed  // 匿名ログイン失敗
    case firebaseError(Error)  // Firebaseエラー

    var errorDescription: String? {
        switch self {
        case .userNotAuthenticated:
            return "ユーザーが認証されていません"
        case .tokenRetrievalFailed:
            return "認証トークンの取得に失敗しました"
        case .anonymousSignInFailed:
            return "匿名ログインに失敗しました"
        case .firebaseError(let error):
            return "認証エラーが発生しました: \(error.localizedDescription)"
        }
    }
}
