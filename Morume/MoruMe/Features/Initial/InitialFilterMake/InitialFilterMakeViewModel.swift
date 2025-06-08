//
//  InitialFilterMakeViewModel.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/28.
//

import Observation
import UIKit

@MainActor
@Observable
final class InitialFilterMakeViewModel {
    private let photoEditRepository: PhotoEditRepository
    private let userRepository: UserRepository
    private let originalPhoto: UIImage

    var editPhoto: UIImage?
    var nickname = ""
    var filterParameters = FilterParameters()

    var isProcessing = false
    var toastEvent: ToastState?
    var showResetAlert = false
    var shouldBackToInitialView: Bool {
        photoEditRepository.detectedFaceMeshes.isEmpty
    }
    var goToNextView = false

    init(originalImage: UIImage) {
        self.originalPhoto = originalImage
        self.photoEditRepository = PhotoEditRepository(originalPhoto: originalImage)
        self.userRepository = MoruMeAPIUserRepository()
    }

    // MARK: フィルター編集
    func detectFaceLandmarks() async {
        isProcessing = true
        defer {
            isProcessing = false
        }

        do {
            try await photoEditRepository.detectFaceAndLandmarks()
            if let faceRegion = photoEditRepository.detectedFaceRegions.first {
                editPhoto = originalPhoto.cropped(to: faceRegion)
            } else {
                editPhoto = originalPhoto
            }
            print("検出された顔の数： \(photoEditRepository.detectedFaceMeshes.count)")
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? "エラーが発生しました"
            toastEvent = ToastState(icon: .errorIcon, message: message, type: .error)
            print(error)
        }
    }

    func applyFilterParameters() {
        guard photoEditRepository.detectedFaceMeshes.count > 0 else {
            print("顔が検出されていません")
            return
        }

        let scales = filterParameters.toScale()

        do {
            let transormedImage = try photoEditRepository.applyTransformations(
                faceIndex: 0,
                eyeScale: CGFloat(scales["eye"]!),
                noseScale: CGFloat(scales["nose"]!),
                mouthScale: CGFloat(scales["mouth"]!)
            )
            if let faceRegion = photoEditRepository.detectedFaceRegions.first {
                editPhoto = transormedImage.cropped(to: faceRegion)
            }
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? "エラーが発生しました"
            toastEvent = ToastState(icon: .errorIcon, message: message, type: .error)
            print("変形の適用に失敗しました: \(error)")
        }
    }

    // MARK: API
    func createFilter() async throws {
        isProcessing = true
        defer {
            isProcessing = false
        }

        _ = try await userRepository.addUser(
            nickname: nickname,
            avatarURL: nil,
            filterParameters: filterParameters
        )
    }
}
