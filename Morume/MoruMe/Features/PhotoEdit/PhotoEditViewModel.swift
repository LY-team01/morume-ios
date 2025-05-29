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

    init(originalImage: UIImage) {
        self.originalPhoto = originalImage
        self.editPhoto = originalImage
        self.photoEditRepository = PhotoEditRepository(originalPhoto: originalImage)
        self.filterRepository = MoruMeAPIFilterRepository()
        self.userRepository = MoruMeAPIUserRepository()
    }

    func detectFaceLandmarks() async {
        isProcessing = true
        defer {
            isProcessing = false
        }

        do {
            try await photoEditRepository.detectFaceAndLandmarks()

            detectedFaces = []
            for index in 0..<photoEditRepository.detectedFaceMeshes.count {
                if index >= faceColors.count {
                    break
                }
                let detectedFace = DetectedFace(
                    faceRegion: photoEditRepository.detectedFaceRegions[index],
                    color: faceColors[index],
                    user: nil,
                    faceMesh: photoEditRepository.detectedFaceMeshes[index]
                )
                detectedFaces.append(detectedFace)
            }
        } catch {
            print(error)
        }
    }
}
