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
    private let originalPhoto: UIImage
    private let faceColors: [Color] = [.red, .orange, .yellow, .green, .blue]

    var editPhoto: UIImage
    var detectedFaces: [DetectedFace] = []

    var isProcessing = false
    var showResetAlert = false
    var hasFaceDetectionCompleted = false

    init(originalImage: UIImage) {
        self.originalPhoto = originalImage
        self.editPhoto = originalImage
        self.photoEditRepository = PhotoEditRepository(originalPhoto: originalImage)
        self.filterRepository = MoruMeAPIFilterRepository()
        self.userRepository = MoruMeAPIUserRepository()
    }

    func detectFaceLandmarks() async {
        // 既に顔検出が完了している場合は再実行しない
        guard !hasFaceDetectionCompleted else { return }

        isProcessing = true
        defer {
            isProcessing = false
        }

        do {
            try await photoEditRepository.detectFaceAndLandmarks()

            // Prepare and sort face data by leftmost X (minX)
            let regions = photoEditRepository.detectedFaceRegions
            let meshes = photoEditRepository.detectedFaceMeshes
            let sortedFaces = zip(regions, meshes)
                .sorted { $0.0.minX < $1.0.minX }

            // Clear and repopulate detectedFaces with colors in sorted order
            detectedFaces = []
            for (index, (region, mesh)) in sortedFaces.enumerated() {
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
        } catch {
            print(error)
        }
    }
}
