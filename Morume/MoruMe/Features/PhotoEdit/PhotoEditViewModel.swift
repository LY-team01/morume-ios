//
//  PhotoEditViewModel.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/29.
//

import Observation
import SwiftUI
import UIKit

@MainActor
@Observable
final class PhotoEditViewModel {
    private let photoEditRepository: PhotoEditRepository
    private let filterRepository: FilterRepository
    private let userRepository: UserRepository
    private let faceColors: [Color] = [.red, .orange, .yellow, .green, .blue]
    let originalPhoto: UIImage

    var editPhoto: UIImage
    var displayedPhoto: UIImage {
        showOriginalPhoto ? originalPhoto : editPhoto
    }
    var detectedFaces: [DetectedFace] = []

    var isProcessing = false
    var showResetAlert = false
    var showOriginalPhoto = false
    var hasFaceDetectionCompleted = false
    var shouldNavigateBack = false

    init(originalImage: UIImage) {
        self.originalPhoto = originalImage
        self.editPhoto = originalImage
        self.photoEditRepository = PhotoEditRepository(originalPhoto: originalImage)
        self.filterRepository = MoruMeAPIFilterRepository()
        self.userRepository = MoruMeAPIUserRepository()
    }

    func detectFaceLandmarks() async -> Bool {
        // 既に顔検出が完了している場合は再実行しない
        guard !hasFaceDetectionCompleted else { return detectedFaces.count > 0 }

        isProcessing = true
        defer {
            isProcessing = false
        }

        do {
            try await photoEditRepository.detectFaceAndLandmarks()

            let regions = photoEditRepository.detectedFaceRegions
            let meshes = photoEditRepository.detectedFaceMeshes

            detectedFaces = []
            for (index, (region, mesh)) in zip(regions, meshes).enumerated() {
                guard index < faceColors.count else { break }
                let detectedFace = DetectedFace(
                    faceRegion: region,
                    color: faceColors[index],
                    user: nil,
                    faceMesh: mesh
                )
                detectedFaces.append(detectedFace)
            }

            // 顔検出完了フラグを設定
            hasFaceDetectionCompleted = true

            // 顔が検出されたかどうかを返す
            return detectedFaces.count > 0
        } catch {
            // エラーログ出力（UIには表示しない - ユーザーが選択する画面なので）
            let message = (error as? LocalizedError)?.errorDescription ?? "顔検出でエラーが発生しました"
            print("顔検出エラー: \(message)")
            print(error)
            return false
        }
    }

    func applyFilterParameters() {
        guard photoEditRepository.detectedFaceMeshes.count > 0 else {
            return
        }

        isProcessing = true
        defer {
            isProcessing = false
        }

        var image = originalPhoto
        for detectedFace in detectedFaces {
            guard let user = detectedFace.user, let faceMesh = detectedFace.faceMesh else {
                continue
            }
            let scales = user.filter!.toScale()

            do {
                image = try photoEditRepository.applyTransformations(
                    to: image,
                    faceMesh: faceMesh,
                    eyeScale: CGFloat(scales["eye"]!),
                    noseScale: CGFloat(scales["nose"]!),
                    mouthScale: CGFloat(scales["mouth"]!)
                )
            } catch {
                let message = (error as? LocalizedError)?.errorDescription ?? "変形の適用でエラーが発生しました"
                print("変形の適用に失敗しました: \(message)")
                print(error)
            }
        }

        editPhoto = image
    }
}
