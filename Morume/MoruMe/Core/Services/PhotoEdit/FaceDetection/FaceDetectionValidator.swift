//
//  FaceDetectionValidator.swift
//  MoruMe
//
//  Created by AI on 2025/06/09.
//

import SwiftUI
import UIKit

/// 顔認識の事前検証を行うサービス
final class FaceDetectionValidator {
    private let faceDetectionService: FaceDetectionService

    init(faceDetectionService: FaceDetectionService = VisionFaceDetectionService()) {
        self.faceDetectionService = faceDetectionService
    }

    /// 画像に顔が含まれているかを検証
    /// - Parameter image: 検証する画像
    /// - Returns: 顔が検出された場合はtrue、それ以外はfalse
    func validateFaceDetection(in image: UIImage) async -> Bool {
        do {
            let faceRegions = try faceDetectionService.detectFaceRegions(in: image)
            return !faceRegions.isEmpty
        } catch {
            print("顔検出エラー: \(error.localizedDescription)")
            return false
        }
    }

    /// 顔認識の検証とエラー表示
    /// - Parameters:
    ///   - image: 検証する画像
    ///   - toastManager: トースト表示用マネージャ
    /// - Returns: 顔が検出された場合はtrue、それ以外はfalse
    func validateAndShowError(for image: UIImage, using toastManager: ToastManager?) async -> Bool {
        let hasDetectedFace = await validateFaceDetection(in: image)

        if !hasDetectedFace, let toastManager = toastManager {
            toastManager.show(
                icon: .errorIcon,
                message: "顔を検出できませんでした。別の写真を選択してください。",
                type: .error
            )
        }

        return hasDetectedFace
    }
}
