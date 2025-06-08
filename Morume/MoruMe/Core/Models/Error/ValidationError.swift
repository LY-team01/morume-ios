//
//  ValidationError.swift
//  MoruMe
//
//  Created by System on 2025/06/08.
//

import Foundation

/// バリデーション関連のエラー
enum ValidationError: Error, LocalizedError {
    case invalidFilterParameters  // 無効なフィルターパラメータ
    case parameterOutOfRange  // パラメータが範囲外

    var errorDescription: String? {
        switch self {
        case .invalidFilterParameters:
            return "無効なフィルターパラメータです"
        case .parameterOutOfRange:
            return "パラメータが範囲外です"
        }
    }
}
