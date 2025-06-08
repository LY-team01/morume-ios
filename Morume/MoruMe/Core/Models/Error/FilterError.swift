//
//  FilterError.swift
//  MoruMe
//
//  Created by System on 2025/06/08.
//

import Foundation

/// フィルター関連のエラー
enum FilterError: Error, LocalizedError {
    case creationFailed  // フィルター作成失敗
    case applicationFailed  // フィルター適用失敗
    case parameterOutOfRange  // パラメータが範囲外
    case filterNotFound  // フィルターが見つからない
    case invalidFilterData  // 無効なフィルターデータ
    case saveFailed  // フィルター保存失敗

    var errorDescription: String? {
        switch self {
        case .creationFailed:
            return "フィルターの作成に失敗しました"
        case .applicationFailed:
            return "フィルターの適用に失敗しました"
        case .parameterOutOfRange:
            return "フィルターパラメータが範囲外です"
        case .filterNotFound:
            return "フィルターが見つかりません"
        case .invalidFilterData:
            return "無効なフィルターデータです"
        case .saveFailed:
            return "フィルターの保存に失敗しました"
        }
    }
}
