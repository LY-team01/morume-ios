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
    var selectedPhoto: UIImage?
    var resultPhoto: UIImage?

    var toastEvent: ToastState?

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
    }
}
