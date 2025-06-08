//
//  HomeViewModel.swift
//  MoruMe
//
//  Created by System on 2025/05/29.
//

import Observation
import Photos
import UIKit

@MainActor
@Observable
final class HomeViewModel {
    private let faceDetectionValidator = FaceDetectionValidator()

    var selectedPhoto: UIImage?
    var resultPhoto: UIImage?
    var shouldNavigate = false
    var toastEvent: ToastState?

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

    func saveResultPhoto() async {
        guard let photo = resultPhoto else {
            toastEvent = ToastState(icon: .errorIcon, message: "エラーが発生しました", type: .error)
            return
        }

        let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
        guard status == .authorized || status == .limited else {
            toastEvent = ToastState(icon: .errorIcon, message: "エラーが発生しました", type: .error)
            return
        }

        UIImageWriteToSavedPhotosAlbum(photo, nil, nil, nil)
        toastEvent = ToastState(icon: .photoSavedIcon, message: "写真を保存しました", type: .success)
    }

    func resetState() {
        selectedPhoto = nil
        resultPhoto = nil
        toastEvent = nil
        shouldNavigate = false
    }
}
