//
//  HomeViewModel.swift
//  MoruMe
//
//  Created by System on 2025/05/29.
//

import Observation
import Photos
import UIKit

@Observable
final class HomeViewModel {
    var selectedPhoto: UIImage?
    var resultPhoto: UIImage?

    var showErrorToast = false
    var showSuccessToast = false

    func saveResultPhoto() {
        guard let photo = resultPhoto else {
            showErrorToast = true
            return
        }

        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized || status == .limited else {
                self.showErrorToast = true
                return
            }

            UIImageWriteToSavedPhotosAlbum(photo, nil, nil, nil)
            self.showSuccessToast = true
        }
    }

    func resetState() {
        selectedPhoto = nil
        resultPhoto = nil
        showErrorToast = false
        showSuccessToast = false
    }
}
