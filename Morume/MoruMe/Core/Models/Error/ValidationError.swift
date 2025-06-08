//
//  ValidationError.swift
//  MoruMe
//
//  Created by System on 2025/06/08.
//

import Foundation

/// バリデーション関連のエラー
enum ValidationError: Error, LocalizedError {
    case emptyNickname  // ニックネーム未入力
    case invalidNickname  // 無効なニックネーム
    case nicknameTooLong  // ニックネームが長すぎる
    case nicknameTooShort  // ニックネームが短すぎる
    case invalidCharacters  // 無効な文字が含まれている
    case invalidFilterParameters  // 無効なフィルターパラメータ
    case parameterOutOfRange  // パラメータが範囲外

    var errorDescription: String? {
        switch self {
        case .emptyNickname:
            return "ニックネームを入力してください"
        case .invalidNickname:
            return "無効なニックネームです"
        case .nicknameTooLong:
            return "ニックネームが長すぎます"
        case .nicknameTooShort:
            return "ニックネームが短すぎます"
        case .invalidCharacters:
            return "使用できない文字が含まれています"
        case .invalidFilterParameters:
            return "無効なフィルターパラメータです"
        case .parameterOutOfRange:
            return "パラメータが範囲外です"
        }
    }
}
