//
//  UserError.swift
//  MoruMe
//
//  Created by System on 2025/06/08.
//

import Foundation

/// ユーザー操作関連のエラー
enum UserError: Error, LocalizedError {
    case profileUpdateFailed  // プロフィール更新失敗
    case dataLoadFailed  // データ読み込み失敗
    case userNotFound  // ユーザーが見つからない
    case duplicateUser  // 重複ユーザー
    case creationFailed  // ユーザー作成失敗
    case updateFailed  // ユーザー更新失敗

    var errorDescription: String? {
        switch self {
        case .profileUpdateFailed:
            return "プロフィールの更新に失敗しました"
        case .dataLoadFailed:
            return "データの読み込みに失敗しました"
        case .userNotFound:
            return "ユーザーが見つかりません"
        case .duplicateUser:
            return "すでに登録されているユーザーです"
        case .creationFailed:
            return "ユーザーの作成に失敗しました"
        case .updateFailed:
            return "ユーザーの更新に失敗しました"
        }
    }
}
