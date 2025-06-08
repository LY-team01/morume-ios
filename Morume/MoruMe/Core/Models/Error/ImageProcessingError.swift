//
//  ImageProcessingError.swift
//  MoruMe
//
//  Created by System on 2025/06/08.
//

import Foundation

/// 画像処理関連のエラー
enum ImageProcessingError: Error, LocalizedError {
    case invalidImage  // 無効な画像
    case processingFailed  // 画像処理失敗
    case meshWarpingFailed  // メッシュワーピング失敗
    case metalRenderingFailed  // Metal描画失敗
    case triangulationFailed  // 三角形分割失敗
    case transformationFailed  // 画像変形失敗
    case cropFailed  // 画像切り取り失敗

    var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "無効な画像です"
        case .processingFailed:
            return "画像処理に失敗しました"
        case .meshWarpingFailed:
            return "メッシュワーピングに失敗しました"
        case .metalRenderingFailed:
            return "Metal描画に失敗しました"
        case .triangulationFailed:
            return "三角形分割に失敗しました"
        case .transformationFailed:
            return "画像変形に失敗しました"
        case .cropFailed:
            return "画像の切り取りに失敗しました"
        }
    }
}
