//
//  ImageUploadViewModel.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/30.
//

import Observation
import UIKit
import SwiftUI

@Observable
@MainActor
final class ImageUploadViewModel {
    private let faceDetectionValidator = FaceDetectionValidator()

    var selectedPhoto: UIImage?
    var toastEvent: ToastState?
    var shouldNavigate = false

    func validateSelectedPhoto() async {
        guard let photo = selectedPhoto else { return }

        // 顔認識チェックを実行
        let hasDetectedFace = await faceDetectionValidator.validateFaceDetection(in: photo)

        if !hasDetectedFace {
            // 顔が検出されなかった場合はエラーを表示し、写真選択をリセット
            toastEvent = ToastState(
                icon: .errorIcon,
                message: "顔を検出できませんでした。別の写真を選択してください。",
                type: .error
            )
            selectedPhoto = nil
            shouldNavigate = false
        } else {
            // 顔が検出された場合は画面遷移フラグをON
            shouldNavigate = true
        }
    }
}
