//
//  FaceDetectionError.swift
//  MoruMe
//
//  Created by System on 2025/06/08.
//

import Foundation

/// 顔検出関連のエラー
enum FaceDetectionError: Error, LocalizedError {
    case noFaceDetected  // 顔が検出されない
    case cgImageConversionFailed  // CGImage変換失敗
    case landmarkDetectionFailed  // ランドマーク検出失敗
    case visionFrameworkError  // Visionフレームワークエラー
    case mediaPipeError  // MediaPipeエラー

    var errorDescription: String? {
        switch self {
        case .noFaceDetected:
            return "顔が検出されませんでした"
        case .cgImageConversionFailed:
            return "画像の変換に失敗しました"
        case .landmarkDetectionFailed:
            return "顔のランドマーク検出に失敗しました"
        case .visionFrameworkError:
            return "顔検出処理でエラーが発生しました"
        case .mediaPipeError:
            return "顔のランドマーク解析でエラーが発生しました"
        }
    }
}
