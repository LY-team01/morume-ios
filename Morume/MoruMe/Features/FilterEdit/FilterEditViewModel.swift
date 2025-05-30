//
//  FilterEditViewModel.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/30.
//

import Observation
import UIKit

@MainActor
@Observable
final class FilterEditViewModel {
    private let photoEditRepository: PhotoEditRepository
    private let userRepository: UserRepository
    private let filterRepository: FilterRepository
    private let originalPhoto: UIImage

    var editPhoto: UIImage?
    var nickname = ""
    var filterParameters = FilterParameters()

    var isProcessing = false
    var showSuccessToast = false
    var showErrorToast = false
    var showResetAlert = false
    var shouldBackToInitialView: Bool {
        photoEditRepository.detectedFaceMeshes.isEmpty
    }

    init(originalImage: UIImage) {
        self.originalPhoto = originalImage
        self.photoEditRepository = PhotoEditRepository(originalPhoto: originalImage)
        self.filterRepository = MoruMeAPIFilterRepository()
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
            let transformedImage = try photoEditRepository.applyTransformations(
                faceIndex: 0,
                eyeScale: CGFloat(scales["eye"]!),
                noseScale: CGFloat(scales["nose"]!),
                mouthScale: CGFloat(scales["mouth"]!)
            )
            if let faceRegion = photoEditRepository.detectedFaceRegions.first {
                editPhoto = transformedImage.cropped(to: faceRegion)
            }
        } catch {
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

    func restoreParameters() async throws {
        isProcessing = true
        defer { isProcessing = false }

        let me = try await userRepository.fetchMyUser()
        self.nickname = me.nickname
        if let filter = me.filter {
            self.filterParameters = filter
        }
    }
}
