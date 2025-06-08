//
//  PhotoLibraryError.swift
//  MoruMe
//
//  Created by System on 2025/06/08.
//

import Foundation

/// 写真ライブラリ関連のエラー
enum PhotoLibraryError: Error, LocalizedError {
    case accessDenied  // アクセス権限なし
    case saveFailed  // 保存失敗
    case imageSelectionFailed  // 画像選択失敗
    case photoLibraryUnavailable  // フォトライブラリ利用不可
    case authorizationFailed  // 認証失敗

    var errorDescription: String? {
        switch self {
        case .accessDenied:
            return "写真ライブラリへのアクセスが拒否されました"
        case .saveFailed:
            return "写真の保存に失敗しました"
        case .imageSelectionFailed:
            return "画像の選択に失敗しました"
        case .photoLibraryUnavailable:
            return "写真ライブラリが利用できません"
        case .authorizationFailed:
            return "写真ライブラリの認証に失敗しました"
        }
    }
}

/// カメラ関連のエラー
enum CameraError: Error, LocalizedError {
    case notAvailable  // カメラ利用不可
    case captureFailed  // 撮影失敗
    case accessDenied  // アクセス権限なし
    case configurationFailed  // 設定失敗

    var errorDescription: String? {
        switch self {
        case .notAvailable:
            return "カメラが利用できません"
        case .captureFailed:
            return "撮影に失敗しました"
        case .accessDenied:
            return "カメラへのアクセスが拒否されました"
        case .configurationFailed:
            return "カメラの設定に失敗しました"
        }
    }
}
