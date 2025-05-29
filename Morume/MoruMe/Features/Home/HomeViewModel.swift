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

    var showErrorToast = false
    var showSuccessToast = false

    func saveResultPhoto() async {
        guard let photo = resultPhoto else {
            showErrorToast = true
            return
        }

        let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
        guard status == .authorized || status == .limited else {
            showErrorToast = true
            return
        }

        UIImageWriteToSavedPhotosAlbum(photo, nil, nil, nil)
        self.showSuccessToast = true
    }

    func resetState() {
        selectedPhoto = nil
        resultPhoto = nil
        showErrorToast = false
        showSuccessToast = false
    }
}
