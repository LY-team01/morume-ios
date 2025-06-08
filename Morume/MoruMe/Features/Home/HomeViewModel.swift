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
        do {
            guard let photo = resultPhoto else {
                throw PhotoLibraryError.imageSelectionFailed
            }

            let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
            guard status == .authorized || status == .limited else {
                throw PhotoLibraryError.accessDenied
            }

            UIImageWriteToSavedPhotosAlbum(photo, nil, nil, nil)
            toastEvent = ToastState(icon: .photoSavedIcon, message: "写真を保存しました", type: .success)
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? "エラーが発生しました"
            toastEvent = ToastState(icon: .errorIcon, message: message, type: .error)
        }
    }

    func resetState() {
        selectedPhoto = nil
        resultPhoto = nil
        toastEvent = nil
    }
}
